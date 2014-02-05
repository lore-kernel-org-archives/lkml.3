Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaBEEnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 23:43:42 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:53324 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbaBEEnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 23:43:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140203193802.GE25625@lukather>
References: <1391398346-5094-1-git-send-email-wens@csie.org>
 <1391398346-5094-9-git-send-email-wens@csie.org> <20140203193802.GE25625@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 5 Feb 2014 12:43:18 +0800
X-Google-Sender-Auth: L80pqrpkQ2TzZUv6CBiG8alPNeI
Message-ID: <CAGb2v659T_QTLChB0NRS0seQvwDBCmTAH6UBEghZng9Ac6uL4g@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] ARM: dts: sun7i: Add ethernet alias for GMAC
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 3:38 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Mon, Feb 03, 2014 at 11:32:26AM +0800, Chen-Yu Tsai wrote:
>> U-Boot will insert MAC address into the device tree image.
>> It looks up ethernet[0-5] aliases to find the ethernet nodes.
>> Alias GMAC as ethernet0, as it is the only ethernet controller used.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  arch/arm/boot/dts/sun7i-a20.dtsi | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
>> index 65fb8d0..c48fb11 100644
>> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
>> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
>> @@ -17,7 +17,7 @@
>>       interrupt-parent = <&gic>;
>>
>>       aliases {
>> -             ethernet0 = &emac;
>> +             ethernet0 = &gmac;
>>       };
>
> I'm not very fond of this patch.
>
> People might rely on the fact that ethernet0 is actually the emac, and
> are expecting u-boot to fill the ethaddr variable to the emac, and not
> the gmac.
>
> Since u-boot is totally able to deal with several ethernet addresses,
> please add it as ethernet1.

Actually I think we should override this in the board dts.
The boards we currently support can only use emac or gmac,
and in our u-boot tree, they have been converted to using
gmac. If any future boards support both emac and gmac, we
can address the ordering then. And the ordering should
match u-boot.

What do you think?


Cheers
ChenYu
