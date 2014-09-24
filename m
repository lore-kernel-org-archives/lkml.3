Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaIXTai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:30:38 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:57463 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaIXTae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:30:34 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Using devices in Containers (was: [lxc-devel] device namespaces)
From: Riya Khanna <riyakhanna1983@gmail.com>
In-Reply-To: <8738bglxsf.fsf_-_@x220.int.ebiederm.org>
Date: Wed, 24 Sep 2014 14:30:30 -0500
Cc: LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Tejun Heo <tj@kernel.org>, Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@ubuntu.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E8CD8839-8FC9-4404-863B-38F36F7D4328@gmail.com>
References: <CALRD3qKmpzJCRszkG_S9Z3XgoTGWVMFd7FqeJh+W-9pZqPVhCg@mail.gmail.com> <87bnq5vcbl.fsf@x220.int.ebiederm.org> <CALRD3qKPJHmmY2DSNNfNKzmLihDLm9fgBQprCXNMHVOArV4iuw@mail.gmail.com> <20140924163740.GD3865@ubuntumail> <8738bglxsf.fsf_-_@x220.int.ebiederm.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 24, 2014, at 12:43 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:

> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> 
>> Isolation is provided by the devices cgroup.  You want something more
>> than isolation.
>> 
>> Quoting riya khanna (riyakhanna1983@gmail.com):
>>> My use case for having device namespaces is device isolation. Isn't what
>>> namespaces are there for (as I understand)?
> 
> Namespaces fundamentally provide for using the same ``global'' name
> in different contexts.  This allows them to be used for isolation
> and process migration (because you can take the same name from
> machine to machine).
> 
> Unless someone cares about device numbers at a namespace level
> the work is done.
> 
> The mount namespace provides exsits to deal with file names.
> The devices cgroup will limit which devices you can access (although
> I can't ever imagine a case where the mout namespace would be
> insufficient).
> 
>>> Not everything should be
>>> accessible (or even visible) from a container all the time (we have seen
>>> people come up with different use cases for this). However, bind-mounting
>>> takes away this flexibility.
> 
> I don't see how.  If they are mounts that propogate into the container
> and are controlled from outside you can do whatever you want.  (I am
> imagining device by device bind mounts here).  It should be trivial
> to have a a directory tree that propogates into a container and works.
> 

Device-by-device bind mounts can grant/revoke access to real individual devices as and when needed. However, revoking the access to real devices could break the applications if there’s no transparent mechanism to back up the propagated (but now revoked) device bind mounts that could fool the apps into believing that they are working with real devices. Frame buffer is one such example, where safe multiplexing could be applied. 

>>> I agree that assigning fixed device numbers is
>>> clearly not a long-term solution. Emulation for safe and flexible
>>> multiplexing, like you suggested either using CUSE/FUSE or something like
>>> devpts, is what I'm exploring.
> 
> Is the problem you actually care about multiplexing devices?
> 

The problem I care about is access to real devices, such as input, fb, loop, etc. as and when needed, thereby having native I/O performance - either through secure multiplexing or exclusive ownership, whatever makes sense according to the device type. 

> I think there is quite a bit of room to talk about how to safely
> and effectively use devices in containers.   So let's make that the
> discussion.  No one actually wants device number namespaces and talking
> about them only muddies the watters.
> 

I cannot agree more. Let’s restrict the discussion to it.

Thanks,
Riya

> Eric

