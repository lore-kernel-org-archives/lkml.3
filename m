Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945Ab3EBTx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:53:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51137 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760842Ab3EBTx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:53:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH, RFC 20/22] media: coda: select GENERIC_ALLOCATOR
Date: Thu, 2 May 2013 21:53:19 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-21-git-send-email-arnd@arndb.de> <1367515255.447627800@f375.mail.ru>
In-Reply-To: <1367515255.447627800@f375.mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305022153.19518.arnd@arndb.de>
X-Provags-ID: V02:K0:rHWpAHsG9HQEhrpNAImbkZSRPh4ykR8Y8aNuZ3UbTpj
 JmkElg+nFFODAI6eajXMmZQQclZJHyXvK/Z75bRsINRslpAiRb
 oPXYwPsdmhmZP9qqzbcyP/JPBoHBji0Ul58kJVL+UQCNSZJgMX
 mBviwqp7FD3JViyD9dE3x2jRZlvSyYJaKRbz+uhGhnQS/Qaz2U
 PUpp4rlGtY5xMlK7fUfh+vduYEuXWdjdoOfSN9JUwGNukKb0xG
 f2TZYZr885J2tulQlgA6AbrOYkmzl8Z06MbO9qkRiSk1lCnL1A
 w5EXbGR1RCPcz0n0n9JIjFphElFDbXoMmcjV3GLCBWPcRLFMSk
 QUk8RhBAF+T5iEO54X/g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Alexander Shiyan wrote:
> > The coda driver uses the generic allocator to get at the
> > "iram" memory, so add the necessary dependency to avoid:
> > 

> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index 0494d27..4608d03 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -145,6 +145,7 @@ config VIDEO_CODA
> >       depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
> >       select VIDEOBUF2_DMA_CONTIG
> >       select V4L2_MEM2MEM_DEV
> > +     select GENERIC_ALLOCATOR
> >       ---help---
> >          Coda is a range of video codec IPs that supports
> >          H.264, MPEG-4, and other video formats.
> 
> Again?
> 

Ah, now I remember where I saw this before -- you sent the same patch, and
Fabio commented that Shawn had already queued up a different solution.

Unfortunately, linux-next as of today is still broken. Shawn, did I
miss a pull request from you?

	Arnd
