Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041Ab3HSQpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:45:53 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:44993 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3HSQpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:45:52 -0400
Message-ID: <52124BD5.5060801@atmel.com>
Date: Mon, 19 Aug 2013 18:46:13 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>, Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Richard Genoud <richard.genoud@gmail.com>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/8] ARM: at91: move peripheral id definitions to dt-bindings
 include dir
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com> <1375339933-3643-1-git-send-email-b.brezillon@overkiz.com> <201308072224.30614.arnd@arndb.de> <520319DE.5090100@overkiz.com>
In-Reply-To: <520319DE.5090100@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 06:09, boris brezillon :
> Hello Arnd,
>
> On 07/08/2013 22:24, Arnd Bergmann wrote:
>> On Thursday 01 August 2013, Boris BREZILLON wrote:
>>> This patch moves peripheral id definitions from machine specific include
>>> dir (arch/arm/mach-at91/include/mach/'soc-name'.h) to dt-bindinds include
>>> dir (include/dt-bindings/at91/'soc-name'/peripherals.h).
>>>
>>> These definitions will be used inside dt to define interrupt ids and
>>> peripheral clk ids.
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> This seems counterproductive, why would you do that?
>
> This was requested by Jean-Christophe Plagniol-Villard (and proposed by
> Richard Genoud)
> for the 3rd version of the "ARM: at91: move to common clk framework"
> patch series (see
> https://lkml.org/lkml/2013/7/29/361) and thought it was a good idea too
> (even if I didn't know
> where to put the macro files as there are no soc specific macro files in
> dt-bindings include
> dir).
>
> Indeed I found it much easier to detect bugs in dt definition using
> macros because
> the macro names and dt node names are the same (it does not protect
> against errors
> in the macro definitions).
>
> If you think these macro definitions should be dropped, I won't argue
> against this.
> But please, have a talk with Jean-Christophe first.

[..]

>> There is no sharing of identifiers across SoCs here, you just move the
>> data around, and changing the .dts files to use the abstract macros would
>> just end up making them harder to understand, not easier, since you then
>> have to look up the numbers in another file.

Boris, Jean-Christophe and Richard,

Well, I must say that I do agree with Arnd on this point.

I think that a simple numeric field in a cell has to be represented as a 
number and even if this simple information is used twice (interrupt 
number and clock bit position in PMC). The possibility of error is very 
low compared to the big amount of unneeded definitions added by this 
solution.

Moreover, I had the hope to completely remove this long list of 
peripheral definitions for all SoC when we have a full DT kernel (with 
your patches about common clock framework). So I think it is not 
interesting to move in this direction and continue to build such a list 
for future full DT products...

Believe me, I am sorry that I didn't entered the discussion earlier and 
avoid unnecessary work... Anyway, give me your opinion, but I do think 
that the simpler is the best.

Bye,
-- 
Nicolas Ferre
