Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaBNSdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:33:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52536 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaBNSdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:33:54 -0500
Message-ID: <52FE618F.4060501@infradead.org>
Date: Fri, 14 Feb 2014 10:33:51 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Holger Waechtler <holger@convergence.de>,
        Oliver Endriss <o.endriss@gmx.de>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 14 (media/pci/ttpci/av7110_ir.c)
References: <20140214162823.0bc09e910a7d1adaaf1c17e6@canb.auug.org.au>
In-Reply-To: <20140214162823.0bc09e910a7d1adaaf1c17e6@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 09:28 PM, Stephen Rothwell wrote:
> Hi all,
> 
> If you see failures in building this tree due to missing declarations of
> k..alloc/free, then it may be caused by commit 2bd59d48ebfb ("cgroup:
> convert to kernfs").  Please send Tejun Heo <tj@kernel.org> a patch
> adding an inclusion of linux/slab.h to the appropriate file(s).
> 
> This tree fails (more than usual) the powerpc allyesconfig build.
> 
> Changes since 20140213:
> 

on i386:

when
CONFIG_DVB_AV7110=y
CONFIG_INPUT=m
CONFIG_INPUT_EVDEV=m


drivers/built-in.o: In function `input_sync':
av7110_ir.c:(.text+0x247276): undefined reference to `input_event'
drivers/built-in.o: In function `av7110_emit_key':
av7110_ir.c:(.text+0x247308): undefined reference to `input_event'
av7110_ir.c:(.text+0x24731e): undefined reference to `input_event'
av7110_ir.c:(.text+0x247384): undefined reference to `input_event'
av7110_ir.c:(.text+0x247399): undefined reference to `input_event'
drivers/built-in.o:av7110_ir.c:(.text+0x2473da): more undefined references to `input_event' follow
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x2475b7): undefined reference to `input_allocate_device'
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x247738): undefined reference to `input_register_device'
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x247748): undefined reference to `input_free_device'
drivers/built-in.o: In function `av7110_ir_exit':
(.text+0x24780a): undefined reference to `input_unregister_device'



-- 
~Randy
