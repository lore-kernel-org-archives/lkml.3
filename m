Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3EAT27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:28:59 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45653 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3EAT2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:28:52 -0400
Date: Wed, 1 May 2013 21:28:45 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for May 1 (media/usb/stk1160)
Message-ID: <20130501192845.GA18811@free.fr>
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
 <518157EB.3010700@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518157EB.3010700@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 10:59:07AM -0700, Randy Dunlap wrote:
> On 05/01/13 01:37, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Please do not add any v3.11 destined work to your linux-next included
> > branches until after v3.10-rc1 is released.
> > 
> > Changes since 20130430:
> > 
> 
> 
> When CONFIG_SND=m and CONFIG_SND_AC97_CODEC=m and
> CONFIG_VIDEO_STK1160=y
> CONFIG_VIDEO_STK1160_AC97=y
> 
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x122706): undefined reference to `snd_card_create'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x1227b2): undefined reference to `snd_ac97_bus'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x1227cd): undefined reference to `snd_card_free'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x12281b): undefined reference to `snd_ac97_mixer'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x122832): undefined reference to `snd_card_register'
> drivers/built-in.o: In function `stk1160_ac97_unregister':
> (.text+0x12285e): undefined reference to `snd_card_free'
> 
> 
> This kconfig fragment:
> config VIDEO_STK1160_AC97
> 	bool "STK1160 AC97 codec support"
> 	depends on VIDEO_STK1160 && SND
> 	select SND_AC97_CODEC
> 
> is unreliable (doesn't do what some people expect) when SND=m and SND_AC97_CODEC=m,
> since VIDEO_STK1160_AC97 is a bool.

I'm not sure to understand what you want, here.
I find it valid that a 'bool' can 'select' a 'tristate', to force it to 'y'.

Do you mean there is an issue with Kconfig, the parser?
  -> should Kconfig warn or error out in such a case?

Or do you mean the structure above is wrong, and should be ammended?
  -> change the 'select' to a 'depends on'?
  -> change the symbol to a tristate?

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
