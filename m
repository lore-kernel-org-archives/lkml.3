Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaG1LKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:10:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbaG1LKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:10:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <53D31D16.1030806@oracle.com>
References: <53D31D16.1030806@oracle.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: dhowells@redhat.com, James Morris <james.l.morris@oracle.com>,
        serge@hallyn.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: security: oops on boot in __key_link_begin
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23130.1406545804.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Jul 2014 12:10:04 +0100
Message-ID: <23131.1406545804@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> wrote:

> I'm (sometimes) seeing the following when booting the most recent -next
> kernel:

Can you try with my keys-next branch?

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-next

That should cut out any interference from other -next stuff.

> [   31.330473] RIP: assoc_array_insert (lib/assoc_array.c:480 lib/assoc_array.c:1021)
> ...
> [   31.330473] ? get_parent_ip (kernel/sched/core.c:2561)
> [   31.330473] ? preempt_count_sub (kernel/sched/core.c:2617)
> [   31.330473] ? put_lock_stats.isra.13 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
> [   31.330473] ? __key_link_begin (./arch/x86/include/asm/bitops.h:311 security/keys/keyring.c:1073)
> [   31.330473] ? __key_link_begin (./arch/x86/include/asm/bitops.h:311 security/keys/keyring.c:1073)
> [   31.330473] __key_link_begin (security/keys/keyring.c:1088)
> [   31.330473] key_create_or_update (security/keys/key.c:840 (discriminator 4))
> [   31.330473] load_system_certificate_list (kernel/system_keyring.c:88)

Given where this is happening, I'm surprised that it doesn't break every
time.  I wonder if it might be some uninitialised memory somewhere:-/

David
