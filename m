Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab3KLRGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:06:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:43710 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab3KLRGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:06:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434011130"
Message-ID: <52825FBE.9060006@intel.com>
Date: Tue, 12 Nov 2013 09:05:02 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Zhi Yong Wu <zwu.kernel@gmail.com>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH v6 07/11] VFS hot tracking: Add a /proc interface to control
 memory usage
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>	<1383745544-391-8-git-send-email-zwu.kernel@gmail.com>	<528156E4.1030409@intel.com> <CAEH94LjoY6L6zDwTh3XKim17VgRTkdqBKpm7TgX0HGok==p+kg@mail.gmail.com>
In-Reply-To: <CAEH94LjoY6L6zDwTh3XKim17VgRTkdqBKpm7TgX0HGok==p+kg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 02:45 PM, Zhi Yong Wu wrote:
> On Tue, Nov 12, 2013 at 6:15 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>> In general, why do you have to control the number of these statically?
> It gives the user or admin one optional chance to control the amount
> of memory consumed by VFS hot tracking. And you can choose not to use
> it.

The on/off knob seems to me to be something better left to a mount
option, not a global tunable.

>> Shouldn't you just define a shrinker and let memory pressure determine
>> how many of these we allow to exist?
> How about if the user and admin hope to control the amount of the
> memory consumed by VFS hot tracking? e.g. If the host has several
> hundred of G or T memory, but the user or admin hope that the memory
> size consumed by VFS hot tracking is under several G, In the case,
> maybe a shrinker of VFS hot tracking will never be invoked by system
> memory module, so this interface will make sense.

If the shrinker is not invoked, that means that there is lots of memory
free.  In the case that there is lots of memory free, are you arguing
that a user would rather see memory go *unused* than be put to use for
this hot tracking data?

If this were true, why don't we have similar knobs for the dentry, inode
and page caches?
