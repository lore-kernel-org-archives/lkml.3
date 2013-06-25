Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3FYJV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:21:59 -0400
Received: from p-mail2.rd.orange.com ([195.101.245.16]:57016 "EHLO
	p-mail2.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3FYJV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:21:57 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: sedat.dilek@gmail.com
Subject: Re: linux-next: Tree for Jun 25
Date: Tue, 25 Jun 2013 11:21:53 +0200
User-Agent: KMail/1.13.5 (Linux/3.9.3-ilmarinen-nv; KDE/4.4.5; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
References: <20130625184420.b811089a069c63ccd3721d68@canb.auug.org.au> <CA+icZUUH7AeR7OSm-SB56AGRiE815tTkQW9fFkKzyrSvzs3Etg@mail.gmail.com>
In-Reply-To: <CA+icZUUH7AeR7OSm-SB56AGRiE815tTkQW9fFkKzyrSvzs3Etg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306251121.53862.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 25 Jun 2013 09:21:54.0400 (UTC) FILETIME=[6ECF6E00:01CE7185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat, All,

On Tuesday 25 June 2013 10:55:20 Sedat Dilek wrote:
> Not sure what's going on, but I get this with today's Linux-Next.
> ( Yesterday's next-20130624 was OK. )
> 
> $ LANG=C LC_ALL=C  yes "" | make oldconfig && LANG=C LC_ALL=C make
> silentoldconfig </dev/null
[--SNIP--]
> RapidIO support (RAPIDIO) [Y/n/?] y
>   IDT Tsi721 PCI Express SRIO Controller support (RAPIDIO_TSI721) [Y/n/?] y
>   Discovery timeout duration (seconds) (RAPIDIO_DISC_TIMEOUT) [30] 30
>   Enable RapidIO Input/Output Ports (RAPIDIO_ENABLE_RX_TX_PORTS) [N/y/?] n
>   DMA Engine support for RapidIO (RAPIDIO_DMA_ENGINE) [Y/n/?] y
>   RapidIO subsystem debug messages (RAPIDIO_DEBUG) [N/y/?] n
>   Enumeration method [M/y/?] (NEW) aborted!
> 
> Console input/output is redirected. Run 'make oldconfig' to update
> configuration.

Yes, the same error as reported by Fengguang earlier:
    http://marc.info/?l=linux-kbuild&m=137214773928335&w=4

And caused by (yet once more):
    8357b48: kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG

Basically, the issue is:

  - 'Enumeration method' is a tristate choice
  - for tristate choices, it is possible to select zero, one or more of the
    symbols in the choice
  - if no symbol is selected (randomly or otherwise) in a tristate choice,
    then the choice symbol itself has no assigned 'value'
  - then silentoldconfig whines

It worked so far as a side effect of another bug (which 8357b48 tries to
fix), and now this new one has been exposed.

I have to think in a calm place tonight, when I'm back from work...

This one is starting to drive me crazy, really... :-(

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
