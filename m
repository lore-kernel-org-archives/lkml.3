Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966684AbaLKXIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:08:24 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:38204 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250AbaLKXIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:08:21 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: Compiled tridentfb hangs but distribution kernel works fine
Date: Fri, 12 Dec 2014 00:07:44 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201412092233.17030.linux@rainbow-software.org> <1418195704.5312.31.camel@marge.simpson.net>
In-Reply-To: <1418195704.5312.31.camel@marge.simpson.net>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201412120007.45242.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2014 08:15:04 Mike Galbraith wrote:
> On Tue, 2014-12-09 at 22:33 +0100, Ondrej Zary wrote:
> > Hello,
> > I'm doing some work on tridentfb driver but encountered a weird problem.
> >
> > When I compile custom kernel with tridentfb, it hangs with Blade3D card
> > (ID 0x9880) in blade_image_blit(). The screen is blank with some
> > artifacts and machine does not respond to ping or keyboard. However, it
> > can be rebooted by Alt+SysRq+B. It works fine with other cards (3DImage
> > 9750 and CyberBlade XP) with no blit implementation. Commenting out
> > contents of blade_image_blit() function makes the hang go away (nothing
> > useful on the screen, of course).
> >
> > The weird thing is that the Blade3D card works fine when I load Debian
> > kernels! Debian 3.16-0.bpo.3-686-pae works fine but when I compile 3.16
> > kernel, it hangs.
> >
> > Any ideas?
>
> I'd start by looking for what Debian changed in source and/or config.

Seems that the problem appears only of CONFIG_CC_OPTIMIZE_FOR_SIZE is enabled. 
Really weird.

-- 
Ondrej Zary
