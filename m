Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab3KLWBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:01:39 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:40464 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab3KLV40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:56:26 -0500
MIME-Version: 1.0
In-Reply-To: <52829751.2090105@intel.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
	<1383745544-391-8-git-send-email-zwu.kernel@gmail.com>
	<528156E4.1030409@intel.com>
	<CAEH94LjoY6L6zDwTh3XKim17VgRTkdqBKpm7TgX0HGok==p+kg@mail.gmail.com>
	<52825FBE.9060006@intel.com>
	<CAEH94Lis9wwgrcnJrJO3LtLoEc07Ze9T_LwpsjVy_yE4XEydyQ@mail.gmail.com>
	<52829751.2090105@intel.com>
Date: Wed, 13 Nov 2013 05:56:24 +0800
Message-ID: <CAEH94LjbKRCvVyd_532gfF4o583tNH7RFE6G0HehWRTV+YGxhA@mail.gmail.com>
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

On Wed, Nov 13, 2013 at 5:02 AM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 11/12/2013 12:38 PM, Zhi Yong Wu wrote:
>> On Wed, Nov 13, 2013 at 1:05 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>>> The on/off knob seems to me to be something better left to a mount
>>> option, not a global tunable.
>> If it is left to a mount option, the user or admin can't change it
>> *dynamically*.
>
> Really?
>
> man mount.  Look at "Mount options for tmpfs".  Try this on an existing
> tmpfs mount:
>
>         mount -o remount,size=$foo tmpfsmount
>
> How would that be different from your tunable?
Is it light weight? I thought that remount will have more overhead and
effect on the applications running on filesystem.

>
>>> If this were true, why don't we have similar knobs for the dentry, inode
>>> and page caches?
>> This is not be controlled by memory controller(mem_cgroup)?
>
> That's a good point.  There is a 'kmem' cgroup controller for
> controlling the in-kernel structures (not page cache which is controlled
> by a separate one).  I believe the 'kmem' one would (could?) apply to
> the hot tracking data structures as well, which would obviate the need
> for this tunable.
>
> At least for the dentry and inode caches, they represent kernel-internal
> cache structures and are the same as your hot-data-tracking structures.
>  We don't have explicit /proc controls for the size of the dentry and
> inode caches, so I'm arguing that we should do the same for these new
> hot-data-tracking structures.
If 'kmem' cgroup controller is applied to VFS hot tracking, need we do
some additional coding work in kernel? If yes, we should put it to
TODO list. You know, we should push VFS hot tracking core to get
merged ASAP at first. Like this interface, we can develop and improve
it later.
I don't know what Viro's opinion is, If he also agree, we can really
put it to TODO list.


>



-- 
Regards,

Zhi Yong Wu
