Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3FYVDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:03:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46395 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3FYVDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:03:20 -0400
Date: Tue, 25 Jun 2013 23:03:14 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: Re: linux-next: Tree for Jun 25
Message-ID: <20130625210314.GC14074@free.fr>
References: <20130625184420.b811089a069c63ccd3721d68@canb.auug.org.au>
 <CA+icZUUH7AeR7OSm-SB56AGRiE815tTkQW9fFkKzyrSvzs3Etg@mail.gmail.com>
 <201306251121.53862.yann.morin.1998@free.fr>
 <CA+icZUU06C43bxyX2UGtDxRQqcyqeAQgt7fZHq7H7HgcJ6sHzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+icZUU06C43bxyX2UGtDxRQqcyqeAQgt7fZHq7H7HgcJ6sHzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat, All,

On 2013-06-25 11:26 +0200, Sedat Dilek spake thusly:
> On Tue, Jun 25, 2013 at 11:21 AM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
> > On Tuesday 25 June 2013 10:55:20 Sedat Dilek wrote:
> >> Not sure what's going on, but I get this with today's Linux-Next.
> >> ( Yesterday's next-20130624 was OK. )
> >>
> >> $ LANG=C LC_ALL=C  yes "" | make oldconfig && LANG=C LC_ALL=C make
> >> silentoldconfig </dev/null
> > [--SNIP--]
> >> RapidIO support (RAPIDIO) [Y/n/?] y
> >>   IDT Tsi721 PCI Express SRIO Controller support (RAPIDIO_TSI721) [Y/n/?] y
> >>   Discovery timeout duration (seconds) (RAPIDIO_DISC_TIMEOUT) [30] 30
> >>   Enable RapidIO Input/Output Ports (RAPIDIO_ENABLE_RX_TX_PORTS) [N/y/?] n
> >>   DMA Engine support for RapidIO (RAPIDIO_DMA_ENGINE) [Y/n/?] y
> >>   RapidIO subsystem debug messages (RAPIDIO_DEBUG) [N/y/?] n
> >>   Enumeration method [M/y/?] (NEW) aborted!
> >>
> >> Console input/output is redirected. Run 'make oldconfig' to update
> >> configuration.
[--SNIP--]
> Bad bad bad Yann, didn't Marek told you to test always with...
> 
>     $ yes "" | make oldconfig; make silentoldconfig </dev/null

If you looked at the commit log, you'd see how I tested this:
    touch defconfig
    for(( i=0; i<10000; i++ )); do
        KCONFIG_ALLCONFIG=$(pwd)/defconfig make randconfig >/dev/null 2>&1
        make silentoldconfig </dev/null >/dev/null 2>&1 || break
    done

That is, 10 thousands random configurations, and none did exhibit the
problem. :-(

Which really means we need a comprehensive test-suite to kconfig.

> Anyway, have fun.

I would not call delving into the kconfig code 'fun'. ;-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
