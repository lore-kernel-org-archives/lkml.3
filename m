Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab3CYQjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:39:24 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:57095 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570Ab3CYQjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <51435534.3090007@tycho.nsa.gov>
References: <CABhRnsWdD6Ef1kg=bud7RKpsQ7KeUhuQEw4Z2N_0RePgS=QDGg@mail.gmail.com>
 <514319D4.6050200@tycho.nsa.gov> <CABhRnsXJ6RJ1wPDy_Z3cHmx8q9zdOHDRi5cxt-PFMKcYVv7xpA@mail.gmail.com>
 <51435534.3090007@tycho.nsa.gov>
From: Thomas COUDRAY <amanone@gmail.com>
Date: Mon, 25 Mar 2013 17:39:01 +0100
Message-ID: <CABhRnsXb3aaV7S6k7fMOZyiZXDepnK11CdSupwVGo3V+Dnv4Tw@mail.gmail.com>
Subject: Re: lgetxattr()/getxattr() return different values on a file labelled
 with selinux disabled
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: jmorris@namei.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/15 Stephen Smalley <sds@tycho.nsa.gov>:
> On 03/15/2013 11:24 AM, Thomas COUDRAY wrote:
>>
>> 2013/3/15 Stephen Smalley <sds@tycho.nsa.gov>:
>>> before_t and after_t are both defined in the policy?
>>
>> Only before_t was defined in the policy.
>
> If not defined in policy, then kernel should remap to unlabeled sid context.

That is not the case.

>>> What are the credentials (capabilities and SELinux security
>>> context/permissions) of the process running the ls and getfattr commands?
>> It has unconfined_u:unconfined_r:before_t label with before_t type.
>> Same as the file f.
>> The process has full SELinux rights on both command and file.
>
> Did it run as root?  Does it have :capability2 mac_override permission?

When I run it as root, both commands return the same label.
The process has mac_override, mac_admin and syslog permission on f.

>>> Any relevant messages from SELinux in dmesg output?
>>
>> No avc warnings in dmesg and audit.log. All looks good.
>
> What about SELinux: messages?  e.g. SELinux:  Context ... is not valid (left
> unmapped).
>

You're right.
> SELinux: Context system_u:object_r:after_t is not valid (left unmapped).

I'm using the modular-base-policy from notebook-source.

--
Thomas Coudray


[    0.021583] SELinux:  Initializing.
[    0.021978] SELinux:  Starting in permissive mode
[    0.765100] EVM: security.selinux
[    1.037649] SELinux:  Registering netfilter hooks
[    4.374957] SELinux: 32 avtab hash slots, 82 rules.
[    4.374966] SELinux: 32 avtab hash slots, 82 rules.
[    4.374968] SELinux:  2 users, 2 roles, 2 types, 0 bools
[    4.374969] SELinux:  82 classes, 82 rules
[    4.375041] SELinux:  Completing initialization.
[    4.375042] SELinux:  Setting up existing superblocks.
[    4.375045] SELinux: initialized (dev sysfs, type sysfs), not
configured for labeling
[    4.375047] SELinux: initialized (dev rootfs, type rootfs), not
configured for labeling
[    4.375122] SELinux: initialized (dev bdev, type bdev), not
configured for labeling
[    4.375125] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    4.375129] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    4.375132] SELinux: initialized (dev devtmpfs, type devtmpfs), not
configured for labeling
[    4.375188] SELinux: initialized (dev debugfs, type debugfs), not
configured for labeling
[    4.375594] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    4.375596] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    4.375598] SELinux: initialized (dev anon_inodefs, type
anon_inodefs), not configured for labeling
[    4.375600] SELinux: initialized (dev devpts, type devpts), uses
transition SIDs
[    4.375603] SELinux: initialized (dev hugetlbfs, type hugetlbfs),
uses transition SIDs
[    4.375605] SELinux: initialized (dev mqueue, type mqueue), uses
transition SIDs
[    4.375607] SELinux: initialized (dev selinuxfs, type selinuxfs),
uses genfs_contexts
[    4.375614] SELinux: initialized (dev securityfs, type securityfs),
not configured for labeling
[    4.375616] SELinux: initialized (dev sysfs, type sysfs), not
configured for labeling
[    4.375746] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    4.375804] SELinux: initialized (dev sda1, type ext4), uses xattr
[    4.929828] SELinux: initialized (dev fusectl, type fusectl), not
configured for labeling
[    4.934859] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    4.936117] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    6.926947] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs),
not configured for labeling
[   17.550807] SELinux: initialized (dev vboxsf, type vboxsf), not
configured for labeling
[   77.497646] SELinux:  Context system_u:object_r:after_t is not
valid (left unmapped).
