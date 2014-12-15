Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaLOOEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:04:12 -0500
Received: from tex.lwn.net ([70.33.254.29]:49319 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaLOOEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:04:10 -0500
Date: Mon, 15 Dec 2014 09:04:04 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RESEND] [media] VIDEO_CAFE_CCIC should select
 VIDEOBUF2_DMA_SG
Message-ID: <20141215090404.6d5cb86e@lwn.net>
In-Reply-To: <1418651737-10016-1-git-send-email-geert@linux-m68k.org>
References: <1418651737-10016-1-git-send-email-geert@linux-m68k.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014 14:55:37 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> If VIDEO_CAFE_CCIC=y, but VIDEOBUF2_DMA_SG=m:
> 
> drivers/built-in.o: In function `mcam_v4l_open':
> mcam-core.c:(.text+0x1c2e81): undefined reference to `vb2_dma_sg_memops'
> mcam-core.c:(.text+0x1c2eb0): undefined reference to `vb2_dma_sg_init_ctx'
> drivers/built-in.o: In function `mcam_v4l_release':
> mcam-core.c:(.text+0x1c34bf): undefined reference to `vb2_dma_sg_cleanup_ctx'

I've been mildly resistant to this because I've never figured out how
such a configuration can come about.  The Cafe chip only appeared in the
OLPC XO-1 and cannot even come close to doing S/G I/O.  So this patch
robs a bit of memory for no use on a platform that can ill afford it.

OTOH, the number of people building contemporary kernels for the XO-1 has
got to be pretty small.  So, in the interest of mollifying randconfig
users out there, you can add my:

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
