Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761785Ab3EDRVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 13:21:54 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:43503 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761677Ab3EDRVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 13:21:52 -0400
Date: Sat, 4 May 2013 14:21:44 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Ezequiel =?utf-8?Q?Garc=C3=ADa?= <elezegarcia@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Splitting stk1160-ac97 as a module (Re: linux-next: Tree for May 1
 (media/usb/stk1160))
Message-ID: <20130504172142.GA21656@localhost>
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
 <518157EB.3010700@infradead.org>
 <51827DB1.7000304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51827DB1.7000304@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Thu, May 02, 2013 at 11:52:33AM -0300, Mauro Carvalho Chehab wrote:
> >
> > is unreliable (doesn't do what some people expect) when SND=m and SND_AC97_CODEC=m,
> > since VIDEO_STK1160_AC97 is a bool.
> 
> Using select is always tricky.
> 
> I can see a few possible fixes for it:
> 
> 1) split the alsa part into a separate module. IMHO, this is cleaner,
> but requires a little more work.
> 

I'm trying to split the ac97 support into a separate module.
So far I've managed to do this with two different approaches,
but both of them are broken in some way :-(

Couple questions:

1. Is it possible to force two symbols to be both built-in (=y) or both
modules (=m)? This would make one of my solutions work.

2. Do you think it's possible to split this as a module *without*
requesting the driver dynamically? I've tried the same extensions approach
as in em28xx and others, but found some problems with the way
snd-usb-audio driver registers.
 
Thanks,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
