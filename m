Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab3HYPE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 11:04:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383Ab3HYPE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 11:04:27 -0400
Subject: Re: [PATCH 2/2] ppc: kvm: use anon_inode_getfd() with O_CLOEXEC flag
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <b7ae23be3a3d4a2f57eca6cfc7f9361da883ceca.1377372576.git.ydroneaud@opteya.com>
Date: Sun, 25 Aug 2013 16:04:21 +0100
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3557EF65-4327-4DAE-999A-B0EE13C433F5@suse.de>
References: <cover.1377372576.git.ydroneaud@opteya.com> <b7ae23be3a3d4a2f57eca6cfc7f9361da883ceca.1377372576.git.ydroneaud@opteya.com>
To: Yann Droneaud <ydroneaud@opteya.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 24.08.2013, at 21:14, Yann Droneaud wrote:

> KVM uses anon_inode_get() to allocate file descriptors as part
> of some of its ioctls. But those ioctls are lacking a flag argument
> allowing userspace to choose options for the newly opened file descriptor.
> 
> In such case it's advised to use O_CLOEXEC by default so that
> userspace is allowed to choose, without race, if the file descriptor
> is going to be inherited across exec().
> 
> This patch set O_CLOEXEC flag on all file descriptors created
> with anon_inode_getfd() to not leak file descriptors across exec().
> 
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> Link: http://lkml.kernel.org/r/cover.1377372576.git.ydroneaud@opteya.com

Reviewed-by: Alexander Graf <agraf@suse.de>

Would it make sense to simply inherit the O_CLOEXEC flag from the parent kvm fd instead? That would give user space the power to keep fds across exec() if it wants to.


Alex

