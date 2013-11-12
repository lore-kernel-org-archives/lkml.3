Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3KLUjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:39:08 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:65029 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab3KLUiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:38:54 -0500
MIME-Version: 1.0
In-Reply-To: <52825FBE.9060006@intel.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
	<1383745544-391-8-git-send-email-zwu.kernel@gmail.com>
	<528156E4.1030409@intel.com>
	<CAEH94LjoY6L6zDwTh3XKim17VgRTkdqBKpm7TgX0HGok==p+kg@mail.gmail.com>
	<52825FBE.9060006@intel.com>
Date: Wed, 13 Nov 2013 04:38:53 +0800
Message-ID: <CAEH94Lis9wwgrcnJrJO3LtLoEc07Ze9T_LwpsjVy_yE4XEydyQ@mail.gmail.com>
Subject: Re: [PATCH v6 07/11] VFS hot tracking: Add a /proc interface to
 control memory usage
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 1:05 AM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 11/11/2013 02:45 PM, Zhi Yong Wu wrote:
>> On Tue, Nov 12, 2013 at 6:15 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>>> In general, why do you have to control the number of these statically?
>> It gives the user or admin one optional chance to control the amount
>> of memory consumed by VFS hot tracking. And you can choose not to use
>> it.
>
> The on/off knob seems to me to be something better left to a mount
> option, not a global tunable.
If it is left to a mount option, the user or admin can't change it
*dynamically*.

>
>>> Shouldn't you just define a shrinker and let memory pressure determine
>>> how many of these we allow to exist?
>> How about if the user and admin hope to control the amount of the
>> memory consumed by VFS hot tracking? e.g. If the host has several
>> hundred of G or T memory, but the user or admin hope that the memory
>> size consumed by VFS hot tracking is under several G, In the case,
>> maybe a shrinker of VFS hot tracking will never be invoked by system
>> memory module, so this interface will make sense.
>
> If the shrinker is not invoked, that means that there is lots of memory
> free.  In the case that there is lots of memory free, are you arguing
> that a user would rather see memory go *unused* than be put to use for
> this hot tracking data?
At first, some user or admin has a lot of use cases which you can't imagine.
If he hope that the usage of memory consumed by VFS hot tracking
doesn't affect other key applications, how about it? This only give
one fine-grained control to the usage of memory consumed by VFS hot
tracking.
>
> If this were true, why don't we have similar knobs for the dentry, inode
> and page caches?
This is not be controlled by memory controller(mem_cgroup)?



-- 
Regards,

Zhi Yong Wu
