Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab3JVIdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:33:06 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51501 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3JVIdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:33:03 -0400
Message-ID: <5266383D.7090709@baylibre.com>
Date: Tue, 22 Oct 2013 10:33:01 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Tony Lindgren <tony@atomide.com>
CC: devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        Jyri Sarha <jsarha@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: am4372: Add McASP nodes
References: <1382348758-1083-1-git-send-email-peter.ujfalusi@ti.com> <526579FB.10005@cogentembedded.com> <52662D3B.5050204@ti.com>
In-Reply-To: <52662D3B.5050204@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/10/2013 09:46, Peter Ujfalusi wrote:
> Hi,
>
> On 10/21/2013 10:01 PM, Sergei Shtylyov wrote:
>
>>> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
>>> index c328d5c..defaad1 100644
>>> --- a/arch/arm/boot/dts/am4372.dtsi
>>> +++ b/arch/arm/boot/dts/am4372.dtsi
>>> @@ -633,5 +633,32 @@
>>>                dma-names = "tx", "rx";
>>>            };
>>>
>>> +        mcasp0: mcasp@48038000 {
>>
>>     According to ePAPR spec [1], "the name of a node should be somewhat
>> generic, reflecting the function of the device and not its
>> precise programming model". In this case probably "sound"?
>
> We use the 'sound' node name for the sound card itself. The case with McASP is
> a bit complicated. It can operate in I2S mode (and similar protocols like RJM,
> LJM, TDM) or it can interface with S/PDIF, IEC60958-1, AES-3 codecs.
> The mode we put McASP depends on the external components, so the same McASP
> can be used in I2S mode in one board while on the other it can be S/PDIF.
> It would have been convenient if I could use 'i2s' as node name but it is not
> true for McASP (Tegra, Exynos for example have I2S, AC97, S/PDIF as separate IP).
>
> IMHO the 'mcasp' is still the best node name for this IP. McASP stands for:
> 'Multichannel Audio Serial Port' and this is pretty much what McASP is.

Yes, I do agree, there are tons of nodes that cannot have generic name. 
Moreover, we are already using that name in few OMAP dts, so for 
consistency, let's keep that name.

Benoit

-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com
