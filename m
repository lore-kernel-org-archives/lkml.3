Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3BNGE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 01:04:57 -0500
Received: from ozlabs.org ([203.10.76.45]:54772 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab3BNGEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 01:04:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: linux-next: Tree for Feb 13 (virtio_console)
In-Reply-To: <511BEC55.5090801@infradead.org>
References: <20130213193532.162080d7c0557a307ab451ac@canb.auug.org.au> <511BEC55.5090801@infradead.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 14 Feb 2013 13:30:37 +1030
Message-ID: <87sj4zk3ai.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

> On 02/13/13 00:35, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Changes since 20130212:
>
> on i386:
>
> drivers/built-in.o: In function `in_intr':
> virtio_console.c:(.text+0x2dd31): undefined reference to `hvc_poll'
> virtio_console.c:(.text+0x2dd41): undefined reference to `hvc_kick'
> drivers/built-in.o: In function `resize_console':
> virtio_console.c:(.text+0x2e26f): undefined reference to `__hvc_resize'
> drivers/built-in.o: In function `unplug_port':
> virtio_console.c:(.text+0x2e572): undefined reference to `hvc_remove'
> drivers/built-in.o: In function `init_port_console':
> (.text+0x2fe59): undefined reference to `hvc_alloc'
> drivers/built-in.o: In function `virtio_cons_early_init':
> (.init.text+0x16d1): undefined reference to `hvc_instantiate'
>
>
> Full randconfig file is attached.

This looks like an impossible config.  CONFIG_VIRTIO_CONSOLE=y, but
CONFIG_HVC_DRIVER isn't set.

>From drivers/char/Kconfig:

        config VIRTIO_CONSOLE
        	tristate "Virtio console"
        	depends on VIRTIO
        	select HVC_DRIVER

???

Cheers,
Rusty.
