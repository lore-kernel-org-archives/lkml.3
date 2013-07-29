Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3G2Vjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:39:47 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:45522 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3G2Vjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:39:46 -0400
MIME-Version: 1.0
In-Reply-To: <1375106520.4223.24.camel@pizza.hi.pengutronix.de>
References: <201307291510.31679.heiko@sntech.de>
	<201307291512.25126.heiko@sntech.de>
	<1375106520.4223.24.camel@pizza.hi.pengutronix.de>
Date: Mon, 29 Jul 2013 16:39:45 -0500
Message-ID: <CAHCPf3vSQHtRkk-_cs3monHfrF-hVx3vTDt1ctcax_bspXDmsg@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] misc: sram: add ability to mark sram sections as reserved
From: Matt Sealey <neko@bakuhatsu.net>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 9:02 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Heiko,
>
> Am Montag, den 29.07.2013, 15:12 +0200 schrieb Heiko Stübner:
>> Some SoCs need parts of their sram for special purposes. So while being part
>> of the peripheral, it should not be part of the genpool controlling the sram.
>>
>> Therefore add an option mmio-sram-reserved to keep arbitrary portions of the
>> sram from being part of the pool.
>>
>> Suggested-by: Rob Herring <robherring2@gmail.com>
>> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
>> Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
>> ---
>> Philipp: I didn't carry the ack, because the loop changed significantly again.
>> So if it looks ok, could you re-ack it please?
>
> I'd prefer the first loop to contain the magic and produce a list of
> useable chunks, instead of a list of reserved blocks. The second loop
> could then iterate over the array and just call gen_pool_add_virt
> repeatedly.
>
> regards
> Philipp

Agreed, however specifying chunks of memory should probably match the
format of the standard memory@ node "available" property - mostly
because it would be the same syntax and definition as defining any
other chunk of memory, as OpenFirmware and device trees have been
doing since the dark ages. In this case, why not re-use the
"available" property name instead of creating a new one? Standard OF
memory parsing code is then free for you to use to pull the chunks
out.

-- 
Matt Sealey <mwsealey@gmail.com>
