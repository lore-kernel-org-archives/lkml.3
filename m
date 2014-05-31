Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaEaJts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 05:49:48 -0400
Received: from mout.gmx.net ([212.227.17.21]:61129 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaEaJtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 05:49:46 -0400
Message-ID: <1401529764.4646.12.camel@schoellingm.dzne.de>
Subject: Re: [PATCH] console: Add persistent scrollback buffers for all VGA
 consoles
From: Manuel Schoelling <manuel.schoelling@gmx.de>
To: Jakub Wilk <jwilk@debian.org>
Cc: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, geert@linux-m68k.org,
        broonie@linaro.org, rdunlap@infradead.org, dh.herrmann@gmail.com,
        airlied@redhat.com, mtosatti@redhat.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 31 May 2014 11:49:24 +0200
In-Reply-To: <20140530222622.GA1385@jwilk.net>
References: <1401456425-15931-1-git-send-email-manuel.schoelling@gmx.de>
	 <20140530222622.GA1385@jwilk.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:mCxjNQaQ/DbhQGtgKOmgDMs9XMYi83VmfNMUdSxZulZbb+kyJVb
 TteC5dpg82VO0308s7gDdRLfbgxSuDA2Uf571tHtQRWi6MwIb1APM5L3lRA2+iBd1TH/0Zq
 sE36vEYPejB9Kg7iyQyUpRymt/8mNOG2DSg1IbcHDWSTUspeIheGa+PwwrrCwdU9qy4RaOh
 D9URrap0nnpC6Uby+HFUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sa, 2014-05-31 at 00:26 +0200, Jakub Wilk wrote:
> * Manuel Schölling <manuel.schoelling@gmx.de>, 2014-05-30, 15:27:
> >Add a scrollback buffers for each VGA console. The benefit is that the 
> >scrollback history is not flushed when switching between consoles but 
> >is persistent.
> 
> Some people rely on this scrollback flushing as a security feature. Is 
> there even another way to clear the scrollback, than to switch to 
> another vt and then back again?
Thanks for raising this security issue! Maybe we should add something
like VT_FLUSH_SCROLLBACK to vt_ioctl()? [1]
I'm open for better ways to flush the scrollback history.

[1] http://lxr.free-electrons.com/source/drivers/tty/vt/vt_ioctl.c#L334

> Debian ships this:
> http://manpages.debian.org/cgi-bin/man.cgi?query=clear_console
> https://sources.debian.net/src/bash/4.2%2Bdfsg-0.1/debian/clear_console.c
> 


