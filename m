Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab3KLVDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:03:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:42356 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab3KLVDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:03:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434136241"
Message-ID: <52829751.2090105@intel.com>
Date: Tue, 12 Nov 2013 13:02:09 -0800
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
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>	<1383745544-391-8-git-send-email-zwu.kernel@gmail.com>	<528156E4.1030409@intel.com>	<CAEH94LjoY6L6zDwTh3XKim17VgRTkdqBKpm7TgX0HGok==p+kg@mail.gmail.com>	<52825FBE.9060006@intel.com> <CAEH94Lis9wwgrcnJrJO3LtLoEc07Ze9T_LwpsjVy_yE4XEydyQ@mail.gmail.com>
In-Reply-To: <CAEH94Lis9wwgrcnJrJO3LtLoEc07Ze9T_LwpsjVy_yE4XEydyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 12:38 PM, Zhi Yong Wu wrote:
> On Wed, Nov 13, 2013 at 1:05 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>> The on/off knob seems to me to be something better left to a mount
>> option, not a global tunable.
> If it is left to a mount option, the user or admin can't change it
> *dynamically*.

Really?

man mount.  Look at "Mount options for tmpfs".  Try this on an existing
tmpfs mount:

	mount -o remount,size=$foo tmpfsmount

How would that be different from your tunable?

>> If this were true, why don't we have similar knobs for the dentry, inode
>> and page caches?
> This is not be controlled by memory controller(mem_cgroup)?

That's a good point.  There is a 'kmem' cgroup controller for
controlling the in-kernel structures (not page cache which is controlled
by a separate one).  I believe the 'kmem' one would (could?) apply to
the hot tracking data structures as well, which would obviate the need
for this tunable.

At least for the dentry and inode caches, they represent kernel-internal
cache structures and are the same as your hot-data-tracking structures.
 We don't have explicit /proc controls for the size of the dentry and
inode caches, so I'm arguing that we should do the same for these new
hot-data-tracking structures.

