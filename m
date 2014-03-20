Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbaCTJup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:50:45 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:47084 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984AbaCTJum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:50:42 -0400
Message-ID: <532AB9EC.1030507@gmail.com>
Date: Thu, 20 Mar 2014 10:50:36 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris BREZILLON <brezillonboris@gmail.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 09/11] ARM: at91/dt: define main xtal frequency of the
 at91sam9261ek board
References: <1395173924-3648-1-git-send-email-b.brezillon.dev@gmail.com>	<1395173924-3648-10-git-send-email-b.brezillon.dev@gmail.com> <CACh+v5OF52ZuDBpkqpev1Jxv0DJ1ckRR+DjcX500i3o0o4HE9A@mail.gmail.com>
In-Reply-To: <CACh+v5OF52ZuDBpkqpev1Jxv0DJ1ckRR+DjcX500i3o0o4HE9A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 20/03/2014 10:24, Jean-Jacques Hiblot a écrit :
> 2014-03-18 21:18 GMT+01:00 Boris BREZILLON <brezillonboris@gmail.com>:
>> Define at91sam9261ek main crystal frequency.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>> ---
>>   arch/arm/boot/dts/at91sam9261ek.dts |    4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/at91sam9261ek.dts b/arch/arm/boot/dts/at91sam9261ek.dts
>> index 2ce527e..7175986 100644
>> --- a/arch/arm/boot/dts/at91sam9261ek.dts
>> +++ b/arch/arm/boot/dts/at91sam9261ek.dts
>> @@ -29,6 +29,10 @@
>>                          compatible = "atmel,osc", "fixed-clock";
>>                          clock-frequency = <18432000>;
>>                  };
>> +
>> +               main_xtal: main_xtal {
>> +                       clock-frequency = <18432000>;
>> +               };
>>          };
>>
>>          ahb {
>> --
>> 1.7.9.5
>>
> You forgot to remove the old fixed-clock definition for the main_clock: clock@0

We need this clock when CCF is disabled (when using the old at91 clk 
implementation).
I'm afraid we'll have to keep it until we move all sam9 SoCs and boards 
to CCF (and DT).

Best Regards,

Boris
>
> Otherwise:
> Acked-by: Jean-Jacques HIBLOT <jjhiblot@traphandler.com>

