Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaIXRnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:43:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40022 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaIXRng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:43:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: riya khanna <riyakhanna1983@gmail.com>
Cc: LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Tejun Heo <tj@kernel.org>, Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@ubuntu.com>
References: <CALRD3qKmpzJCRszkG_S9Z3XgoTGWVMFd7FqeJh+W-9pZqPVhCg@mail.gmail.com>
	<87bnq5vcbl.fsf@x220.int.ebiederm.org>
	<CALRD3qKPJHmmY2DSNNfNKzmLihDLm9fgBQprCXNMHVOArV4iuw@mail.gmail.com>
	<20140924163740.GD3865@ubuntumail>
Date: Wed, 24 Sep 2014 10:43:12 -0700
In-Reply-To: <20140924163740.GD3865@ubuntumail> (Serge Hallyn's message of
	"Wed, 24 Sep 2014 16:37:40 +0000")
Message-ID: <8738bglxsf.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/C/rZjEcu0WEOey0z+qdJAN/5Fbm6+xXs=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.4 XM_Superlative01 Best-rated language
	*  0.7 XMSubLong Long Subject
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4762]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;riya khanna <riyakhanna1983@gmail.com>
X-Spam-Relay-Country: 
Subject: Using devices in Containers (was: [lxc-devel] device namespaces)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Isolation is provided by the devices cgroup.  You want something more
> than isolation.
>
> Quoting riya khanna (riyakhanna1983@gmail.com):
>> My use case for having device namespaces is device isolation. Isn't what
>> namespaces are there for (as I understand)?

Namespaces fundamentally provide for using the same ``global'' name
in different contexts.  This allows them to be used for isolation
and process migration (because you can take the same name from
machine to machine).

Unless someone cares about device numbers at a namespace level
the work is done.

The mount namespace provides exsits to deal with file names.
The devices cgroup will limit which devices you can access (although
I can't ever imagine a case where the mout namespace would be
insufficient).

>> Not everything should be
>> accessible (or even visible) from a container all the time (we have seen
>> people come up with different use cases for this). However, bind-mounting
>> takes away this flexibility.

I don't see how.  If they are mounts that propogate into the container
and are controlled from outside you can do whatever you want.  (I am
imagining device by device bind mounts here).  It should be trivial
to have a a directory tree that propogates into a container and works.

>> I agree that assigning fixed device numbers is
>> clearly not a long-term solution. Emulation for safe and flexible
>> multiplexing, like you suggested either using CUSE/FUSE or something like
>> devpts, is what I'm exploring.

Is the problem you actually care about multiplexing devices?

I think there is quite a bit of room to talk about how to safely
and effectively use devices in containers.   So let's make that the
discussion.  No one actually wants device number namespaces and talking
about them only muddies the watters.

Eric
