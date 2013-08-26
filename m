Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab3HZHjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 03:39:23 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:61259 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3HZHjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 03:39:21 -0400
Message-ID: <521B0622.9090208@redhat.com>
Date: Mon, 26 Aug 2013 09:39:14 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Yann Droneaud <ydroneaud@opteya.com>, Gleb Natapov <gleb@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ppc: kvm: use anon_inode_getfd() with O_CLOEXEC flag
References: <cover.1377372576.git.ydroneaud@opteya.com> <b7ae23be3a3d4a2f57eca6cfc7f9361da883ceca.1377372576.git.ydroneaud@opteya.com> <3557EF65-4327-4DAE-999A-B0EE13C433F5@suse.de>
In-Reply-To: <3557EF65-4327-4DAE-999A-B0EE13C433F5@suse.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/08/2013 17:04, Alexander Graf ha scritto:
> 
> On 24.08.2013, at 21:14, Yann Droneaud wrote:
> 
>> KVM uses anon_inode_get() to allocate file descriptors as part
>> of some of its ioctls. But those ioctls are lacking a flag argument
>> allowing userspace to choose options for the newly opened file descriptor.
>>
>> In such case it's advised to use O_CLOEXEC by default so that
>> userspace is allowed to choose, without race, if the file descriptor
>> is going to be inherited across exec().
>>
>> This patch set O_CLOEXEC flag on all file descriptors created
>> with anon_inode_getfd() to not leak file descriptors across exec().
>>
>> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
>> Link: http://lkml.kernel.org/r/cover.1377372576.git.ydroneaud@opteya.com
> 
> Reviewed-by: Alexander Graf <agraf@suse.de>
> 
> Would it make sense to simply inherit the O_CLOEXEC flag from the
> parent kvm fd instead? That would give user space the power to keep
> fds across exec() if it wants to.

Does it make sense to use non-O_CLOEXEC file descriptors with KVM at
all?  Besides fork() not being supported by KVM, as described in
Documentation/virtual/kvm/api.txt, the VMAs of the parent process go
away as soon as you exec().  I'm not sure how you can use the inherited
file descriptor in a sensible way after exec().

Paolo
