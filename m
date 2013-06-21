Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945952Ab3FUTkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:40:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945926Ab3FUTk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:40:29 -0400
Date: Fri, 21 Jun 2013 16:40:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: randconfig build error with next-20130620, in
 drivers/media/pci/ngene
Message-ID: <20130621164022.6b9ffd7f@redhat.com>
In-Reply-To: <20130620212318.GA5648@krebstar.arl.arizona.edu>
References: <20130620212318.GA5648@krebstar.arl.arizona.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

Thanks for reporting it.

Em Thu, 20 Jun 2013 14:23:18 -0700
Jim Davis <jim.epost@gmail.com> escreveu:

> Building with the attached random configuration file, 

There was a hard to track issue there that started to appear after
changeset 7b34be71db53 (and a few similar ones), but was actually
caused by a much older issue. In summary: while before that changeset
the tree builds with random configs, the compiled media drivers won't
work under certain conditions[1].

This got fixed on this changeset:
	http://git.linuxtv.org/media_tree.git/commit/bb69ee27b96110c509d5b92c9ee541d81a821706

[1] This is not as serious as it seems, because those random configs
don't make much sense by a normal user, and no distro uses those weird
configs. The error happens when:
	- the main driver is builtin;
	- the tuner and/or driver is module;
	- CONFIG_MEDIA_ATTACH is not set

When CONFIG_MEDIA_ATTACH is enabled, the main driver will load the needed
modules before calling the needed module attach functions.

I'm sending a pull request with this patch (plus a few other fixes) in a few.

> 
>   LD      init/built-in.o
> drivers/built-in.o: In function `demod_attach_lg330x':
> ngene-cards.c:(.text+0x49dd70): undefined reference to `lgdt330x_attach'
> drivers/built-in.o: In function `cineS2_probe':
> ngene-cards.c:(.text+0x49e48e): undefined reference to `drxk_attach'
> drivers/built-in.o: In function `dibusb_dib3000mc_tuner_attach':
> (.text+0x4a2b92): undefined reference to `mt2060_attach'
> drivers/built-in.o: In function `digitv_frontend_attach':
> digitv.c:(.text+0x4a3055): undefined reference to `nxt6000_attach'
> drivers/built-in.o: In function `opera1_frontend_attach':
> opera1.c:(.text+0x4a3c9d): undefined reference to `stv0299_attach'
> drivers/built-in.o: In function `af9005_fe_init':
> af9005-fe.c:(.text+0x4a69e5): undefined reference to `mt2060_attach'
> drivers/built-in.o: In function `pctv452e_tuner_attach':
> pctv452e.c:(.text+0x4a7c1c): undefined reference to `stb6100_attach'
> drivers/built-in.o: In function `dw2104_frontend_attach':
> dw2102.c:(.text+0x4a9ee7): undefined reference to `stb6100_attach'
> dw2102.c:(.text+0x4a9fab): undefined reference to `cx24116_attach'
> drivers/built-in.o: In function `dw2102_frontend_attach':
> dw2102.c:(.text+0x4aa41e): undefined reference to `stv0299_attach'
> drivers/built-in.o: In function `m88rs2000_frontend_attach':
> dw2102.c:(.text+0x4aaa89): undefined reference to `m88rs2000_attach'
> drivers/built-in.o: In function `af9035_tuner_attach':
> af9035.c:(.text+0x4aed42): undefined reference to `tda18218_attach'
> af9035.c:(.text+0x4aedd4): undefined reference to `fc2580_attach'
> drivers/built-in.o: In function `anysee_tuner_attach':
> anysee.c:(.text+0x4b0bd1): undefined reference to `isl6423_attach'
> drivers/built-in.o: In function `anysee_frontend_attach':
> anysee.c:(.text+0x4b0d97): undefined reference to `zl10353_attach'
> anysee.c:(.text+0x4b0df2): undefined reference to `zl10353_attach'
> anysee.c:(.text+0x4b0e75): undefined reference to `cx24116_attach'
> anysee.c:(.text+0x4b1000): undefined reference to `zl10353_attach'
> anysee.c:(.text+0x4b1033): undefined reference to `zl10353_attach'
> anysee.c:(.text+0x4b1110): undefined reference to `zl10353_attach'
> drivers/built-in.o: In function `az6007_frontend_attach':
> az6007.c:(.text+0x4b1d58): undefined reference to `drxk_attach'
> make: *** [vmlinux] Error 1


Regard
-- 

Cheers,
Mauro
