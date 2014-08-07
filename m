Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbaHGQoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:44:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56825 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbaHGQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:44:37 -0400
MIME-Version: 1.0
In-Reply-To: <ABE15994-F47B-4E4B-A6FC-79C6BCAC9FF3@holtmann.org>
References: <1407424003-15073-1-git-send-email-geert@linux-m68k.org>
	<ABE15994-F47B-4E4B-A6FC-79C6BCAC9FF3@holtmann.org>
Date: Thu, 7 Aug 2014 18:44:35 +0200
X-Google-Sender-Auth: rh4CX_D4oru71dtz-vRwsunACGk
Message-ID: <CAMuHMdU214_aDNQBH=Nk6DZwsdCB3FQY1DY0ZQ8WQGQ86dGFUQ@mail.gmail.com>
Subject: Re: [PATCH] 6lowpan: Allow 6LoWPAN to be modular
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel@lists.sourceforge.net,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        linux-wpan@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

On Thu, Aug 7, 2014 at 6:00 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
>> Change config symbol 6LOWPAN from type bool to type tristate, so
>> 6LoWPAN can be built modular, just like IPV6
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>> net/6lowpan/Kconfig | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/6lowpan/Kconfig b/net/6lowpan/Kconfig
>> index 028a5c6d1f61..e4a02ef55102 100644
>> --- a/net/6lowpan/Kconfig
>> +++ b/net/6lowpan/Kconfig
>> @@ -1,5 +1,5 @@
>> config 6LOWPAN
>> -     bool "6LoWPAN Support"
>> +     tristate "6LoWPAN Support"
>
> is this a regression from the previous CONFIG_6LOWPAN separation that we introduced? If it is, then it might be easiest if Dave just takes it into his net tree. Otherwise I take it through bluetooth-next.

I hadn't thought about that... Checking...

Yes, I believe this is a regression.

In v3.16, my allmodconfig build had:

CONFIG_IEEE802154_6LOWPAN=m
CONFIG_6LOWPAN_IPHC=m
CONFIG_BT_6LOWPAN=y

Without my patch it has:

CONFIG_6LOWPAN=y
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_BT_6LOWPAN=m

and iphc is what's in net/6lowpan/built-in.o now.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
