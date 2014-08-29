Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaH2TXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:23:52 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36078 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaH2TXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:23:50 -0400
MIME-Version: 1.0
In-Reply-To: <5400C3E8.9040500@broadcom.com>
References: <1409329464-768-1-git-send-email-geert@linux-m68k.org>
	<5400C3E8.9040500@broadcom.com>
Date: Fri, 29 Aug 2014 21:23:48 +0200
X-Google-Sender-Auth: VBuXNMIUf3_TUYIb2oymYxSED9A
Message-ID: <CAMuHMdXahUGQ1-4SvkCnt=BrAn6_Xge7RzieR2K8gDmj_pC-kw@mail.gmail.com>
Subject: Re: [PATCH] brcmfmac: BRCMFMAC should depend on HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Franky Lin <frankyl@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list@broadcom.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Franky,

On Fri, Aug 29, 2014 at 8:18 PM, Franky Lin <frankyl@broadcom.com> wrote:
>>   config BRCMFMAC
>>         tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
>> -       depends on CFG80211
>> +       depends on CFG80211A && HAS_DMA
>>         select BRCMUTIL
>>         ---help---
>>           This module adds support for embedded wireless adapters based on
>
> Thanks for reporting this. All complaints are from msgbuf code. So the
> dependency should belong to BRCMFMAC_PCIE not BRCMFMAC.

I have PCI=n, hence BRCMFMAC_PCIE=n.

IIRC, I did try adding the HAS_DMA dependencies to the suboptions,
but then it still failed to link. Hence I restored to the main BRCMFMAC.

Besides, msgbuf.o is part of the core.
I've just tried moving it to brcmfmac-$(CONFIG_BRCMFMAC_PCIE),
but that doesn't help. Other parts use msgbuf, too.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
