Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3HZIXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:23:21 -0400
Received: from mx-out.ocsa-data.net ([194.36.166.37]:54703 "EHLO
	mx-out.ocsa-data.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab3HZIXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:23:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Mon, 26 Aug 2013 10:23:12 +0200
From: Yann Droneaud <ydroneaud@opteya.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH 2/2] ppc: kvm: use =?UTF-8?Q?anon=5Finode=5Fgetfd=28?=
 =?UTF-8?Q?=29=20with=20O=5FCLOEXEC=20flag?=
Organization: OPTEYA
In-Reply-To: <521B0622.9090208@redhat.com>
References: <cover.1377372576.git.ydroneaud@opteya.com>
 <b7ae23be3a3d4a2f57eca6cfc7f9361da883ceca.1377372576.git.ydroneaud@opteya.com>
 <3557EF65-4327-4DAE-999A-B0EE13C433F5@suse.de> <521B0622.9090208@redhat.com>
Message-ID: <156342996ba92cb5f49519b0c2e9d6ac@meuh.org>
User-Agent: Roundcube Webmail/0.9.2
X-abuse-contact: abuse@ocsa-data.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 26.08.2013 09:39, Paolo Bonzini a écrit :
> Il 25/08/2013 17:04, Alexander Graf ha scritto:
>> On 24.08.2013, at 21:14, Yann Droneaud wrote:
>> 
>>> 
>>> This patch set O_CLOEXEC flag on all file descriptors created
>>> with anon_inode_getfd() to not leak file descriptors across exec().
>>> 
>>> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
>>> Link: 
>>> http://lkml.kernel.org/r/cover.1377372576.git.ydroneaud@opteya.com
>> 
>> Reviewed-by: Alexander Graf <agraf@suse.de>
>> 
>> Would it make sense to simply inherit the O_CLOEXEC flag from the
>> parent kvm fd instead? That would give user space the power to keep
>> fds across exec() if it wants to.
> 
> Does it make sense to use non-O_CLOEXEC file descriptors with KVM at
> all?  Besides fork() not being supported by KVM, as described in
> Documentation/virtual/kvm/api.txt, the VMAs of the parent process go
> away as soon as you exec().  I'm not sure how you can use the inherited
> file descriptor in a sensible way after exec().
> 

Sounds a lot like InfiniBand subsystem behavor: IB file descriptors
are of no use accross exec() since memory mappings tied to those fds
won't be available in the new process:

https://lkml.org/lkml/2013/7/8/380
http://mid.gmane.org/f58540dc64fec1ac0e496dfcd3cc1af7@meuh.org

Regards.

-- 
Yann Droneaud
OPTEYA

