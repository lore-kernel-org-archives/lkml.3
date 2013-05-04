Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3EDT76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 15:59:58 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50987 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3EDT74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 15:59:56 -0400
Date: Sat, 4 May 2013 21:59:50 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ezequiel =?iso-8859-1?Q?Garc=EDa?= <elezegarcia@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: Splitting stk1160-ac97 as a module (Re: linux-next: Tree for May
 1 (media/usb/stk1160))
Message-ID: <20130504195950.GA3254@free.fr>
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
 <518157EB.3010700@infradead.org>
 <51827DB1.7000304@redhat.com>
 <20130504172142.GA21656@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130504172142.GA21656@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ezequiel, All,

On Sat, May 04, 2013 at 02:21:44PM -0300, Ezequiel Garcia wrote:
> I'm trying to split the ac97 support into a separate module.
> So far I've managed to do this with two different approaches,
> but both of them are broken in some way :-(
> 
> Couple questions:
> 
> 1. Is it possible to force two symbols to be both built-in (=y) or both
> modules (=m)? This would make one of my solutions work.

If they are always the same value, there is no need to have two symbols
in the first place.

However, given the original problem from this thread, if what you meant
was to have the second symbol either 'n' or the same as the first symbol,
ie. the following table:

    A:  n   m   m   y   y
    B:  n   n   m   n   y

Then the closest I came up with is:

    config MODULES
        bool "Modules"
    
    config A
        tristate "A"
    
    config B_dummy
        bool "B"
        depends on A
    
    config B
        tristate
        default m if A=m && B_dummy
        default y if A=y && B_dummy

where B_dummy is not used outside of Kconfig, and only A and B are the
symbols of interest (eg. to build the drivers).

Otherwise, I was not able to get the desired behviour with only the A
and B symbols.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
