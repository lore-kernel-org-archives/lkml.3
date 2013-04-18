Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab3DRLhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:37:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56500 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab3DRLhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:37:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 24/32] dmaengine: ste_dma40: Supply full Device Tree parsing support
Date: Thu, 18 Apr 2013 13:37:32 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <201304181306.34835.arnd@arndb.de> <20130418113138.GD27903@gmail.com>
In-Reply-To: <20130418113138.GD27903@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181337.32700.arnd@arndb.de>
X-Provags-ID: V02:K0:5adOEgooOQrRgpjM0dHqKs/0Cat3Owv61cMxiPo0okT
 JcKOO97gYoqrv2304OXJKQWjbSq3/gcUBNPiTU5M4JlI4SXiH0
 +BiDfeXtr85bC4qQL2WtsadQmBsGkGRm2KGddYc9OAc1OcAxRT
 dDtkBK7bTPXUDyjvmoCxKQx7USqztBtLuS3IQG+VmoZwO5if8O
 Q6FtCuqAm5grsQr3EfP/I2c6p9hWDK2gDzRFPUxiuSph6xh1PS
 Yb4OQBNsFbD7o1DmhFkqvjKpoSJLSIOhV3P+FJrzlXFlUEImYo
 aiKy9hW3fVMQlppiE6dY4ZXlu1JJ07UHmpMR4bHpe77aURwzC6
 IxjKBO49PwkeAMNhGP5A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> You're right, I am a little confused by them.
> 
> I call them 'device type' because that's what they're called already.
> Grep for 'dma_dev_type'. This is the number which gets split into
> event group and line, like this:
> 
>         event_group = D40_TYPE_TO_GROUP(dev_type);
>         event_line = D40_TYPE_TO_EVENT(dev_type);
> 
> > and I would put that number first.
> 
> So you want me to switch that round so it looks like:
> 
>         dmas = <<phandle> <dev_type> <fixed_chan> <flags>;
> 
> Instead of what I have at the moment:
> 
>         dmas = <<phandle> <fixed_chan> <dev_type> <flags>;
> 
> Correct?

Yes, that's probably better and more in line with what the other
drivers do. You could also put the fixed_chan last if that helps.

I would still like to get a confirmation that we actually still
require the fixed channel assignment, since it's just used
in one driver, and that might only be needed for some buggy
hardware revision if we're lucky.

	Arnd
