Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3FYJ03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:26:29 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37030 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3FYJ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:26:27 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201306251121.53862.yann.morin.1998@free.fr>
References: <20130625184420.b811089a069c63ccd3721d68@canb.auug.org.au>
	<CA+icZUUH7AeR7OSm-SB56AGRiE815tTkQW9fFkKzyrSvzs3Etg@mail.gmail.com>
	<201306251121.53862.yann.morin.1998@free.fr>
Date: Tue, 25 Jun 2013 11:26:25 +0200
Message-ID: <CA+icZUU06C43bxyX2UGtDxRQqcyqeAQgt7fZHq7H7HgcJ6sHzQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 25
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:21 AM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
> Sedat, All,
>
> On Tuesday 25 June 2013 10:55:20 Sedat Dilek wrote:
>> Not sure what's going on, but I get this with today's Linux-Next.
>> ( Yesterday's next-20130624 was OK. )
>>
>> $ LANG=C LC_ALL=C  yes "" | make oldconfig && LANG=C LC_ALL=C make
>> silentoldconfig </dev/null
> [--SNIP--]
>> RapidIO support (RAPIDIO) [Y/n/?] y
>>   IDT Tsi721 PCI Express SRIO Controller support (RAPIDIO_TSI721) [Y/n/?] y
>>   Discovery timeout duration (seconds) (RAPIDIO_DISC_TIMEOUT) [30] 30
>>   Enable RapidIO Input/Output Ports (RAPIDIO_ENABLE_RX_TX_PORTS) [N/y/?] n
>>   DMA Engine support for RapidIO (RAPIDIO_DMA_ENGINE) [Y/n/?] y
>>   RapidIO subsystem debug messages (RAPIDIO_DEBUG) [N/y/?] n
>>   Enumeration method [M/y/?] (NEW) aborted!
>>
>> Console input/output is redirected. Run 'make oldconfig' to update
>> configuration.
>
> Yes, the same error as reported by Fengguang earlier:
>     http://marc.info/?l=linux-kbuild&m=137214773928335&w=4
>

Hmm, I read that posting, but was not aware it affects me.

> And caused by (yet once more):
>     8357b48: kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
>
> Basically, the issue is:
>
>   - 'Enumeration method' is a tristate choice

Yupp.

http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=a11650e11093ed57dca78bf16e7836517c599098

>   - for tristate choices, it is possible to select zero, one or more of the
>     symbols in the choice
>   - if no symbol is selected (randomly or otherwise) in a tristate choice,
>     then the choice symbol itself has no assigned 'value'
>   - then silentoldconfig whines

Bad bad bad Yann, didn't Marek told you to test always with...

    $ yes "" | make oldconfig; make silentoldconfig </dev/null

Anyway, have fun.

- Sedat -

>
> It worked so far as a side effect of another bug (which 8357b48 tries to
> fix), and now this new one has been exposed.
>
> I have to think in a calm place tonight, when I'm back from work...
>
> This one is starting to drive me crazy, really... :-(
>
> Regards,
> Yann E. MORIN.
>
> --
> .-----------------.--------------------.------------------.--------------------.
> |  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
> | +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
> | --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
> | http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
> '------------------------------'-------'------------------'--------------------'
