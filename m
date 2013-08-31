Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab3HaSV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 14:21:29 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2835 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab3HaSV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 14:21:27 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <5222341B.4070205@broadcom.com>
Date: Sat, 31 Aug 2013 20:21:15 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
cc: "Randy Dunlap" <rdunlap@infradead.org>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list@broadcom.com,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 30 (brcmfmac)
References: <20130829200013.d9dde1eb64686a32c661b5d3@canb.auug.org.au>
 <52210AB9.2090104@infradead.org>
 <CAMuHMdXFmWyiUJF+4HbD=6oGPVXHBAVx=rOC7u=motTQFCKn7g@mail.gmail.com>
In-Reply-To: <CAMuHMdXFmWyiUJF+4HbD=6oGPVXHBAVx=rOC7u=motTQFCKn7g@mail.gmail.com>
X-WSS-ID: 7E3CECBE0UO2710840-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/13 19:37, Geert Uytterhoeven wrote:
> On Fri, Aug 30, 2013 at 11:12 PM, Randy Dunlap<rdunlap@infradead.org>  wrote:
>> This bool kconfig symbol:
>>
>> config BRCMFMAC_SDIO
>>          bool "SDIO bus interface support for FullMAC driver"
>>          depends on MMC
>>
>> allows BRCMFMAC_SDIO to be y even when MMC=m.
>>
>> Is there a reasonable solution to this?

Actually, BRCMFMAC should be built in same form as the MMC and/or USB, 
but only when BRCMFMAC_SDIO or BRCMFMAC_USB are selected.

So valid combinations are:
MMC=m, USB=m, BRCMFMAC_SDIO=y, BRCMFMAC_USB=y => BRCMFMAC=m
MMC=m, USB=y, BRCMFMAC_SDIO=y, BRCMFMAC_USB=y => BRCMFMAC=m
MMC=y, USB=m, BRCMFMAC_SDIO=y, BRCMFMAC_USB=y => BRCMFMAC=m
MMC=m, USB=y, BRCMFMAC_SDIO=y, BRCMFMAC_USB=n => BRCMFMAC=m
MMC=m, USB=y, BRCMFMAC_SDIO=n, BRCMFMAC_USB=y => BRCMFMAC=m|y
MMC=y, USB=m, BRCMFMAC_SDIO=y, BRCMFMAC_USB=n => BRCMFMAC=m|y
MMC=y, USB=m, BRCMFMAC_SDIO=n, BRCMFMAC_USB=y => BRCMFMAC=m
MMC=y, USB=y, BRCMFMAC_SDIO=y, BRCMFMAC_USB=y => BRCMFMAC=m|y
MMC=y, USB=y, BRCMFMAC_SDIO=y, BRCMFMAC_USB=n => BRCMFMAC=m|y
MMC=y, USB=y, BRCMFMAC_SDIO=n, BRCMFMAC_USB=y => BRCMFMAC=m|y

Not sure how to express the above.

Gr. AvS

> In order of preference:
> 1. Make it tristate
> 2. depends on MMC=y
>
> However, the first solution cannot be used as there are several
> "#ifdef CONFIG_BRCMFMAC_SDIO" in the code itself.
>
> Note that there's a similar issue with BRCMFMAC_USB and USB.
>
> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
>


