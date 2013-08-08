Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3HHEQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 00:16:02 -0400
Received: from 15.mo4.mail-out.ovh.net ([91.121.62.11]:59789 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752038Ab3HHEQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 00:16:00 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2013 00:16:00 EDT
Message-ID: <520319DE.5090100@overkiz.com>
Date: Thu, 08 Aug 2013 06:09:02 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH 1/8] ARM: at91: move peripheral id definitions to dt-bindings
 include dir
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com> <1375339933-3643-1-git-send-email-b.brezillon@overkiz.com> <201308072224.30614.arnd@arndb.de>
In-Reply-To: <201308072224.30614.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 1924444416330659844
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On 07/08/2013 22:24, Arnd Bergmann wrote:
> On Thursday 01 August 2013, Boris BREZILLON wrote:
>> This patch moves peripheral id definitions from machine specific include
>> dir (arch/arm/mach-at91/include/mach/'soc-name'.h) to dt-bindinds include
>> dir (include/dt-bindings/at91/'soc-name'/peripherals.h).
>>
>> These definitions will be used inside dt to define interrupt ids and
>> peripheral clk ids.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> This seems counterproductive, why would you do that?

This was requested by Jean-Christophe Plagniol-Villard (and proposed by 
Richard Genoud)
for the 3rd version of the "ARM: at91: move to common clk framework" 
patch series (see
https://lkml.org/lkml/2013/7/29/361) and thought it was a good idea too 
(even if I didn't know
where to put the macro files as there are no soc specific macro files in 
dt-bindings include
dir).

Indeed I found it much easier to detect bugs in dt definition using 
macros because
the macro names and dt node names are the same (it does not protect 
against errors
in the macro definitions).

If you think these macro definitions should be dropped, I won't argue 
against this.
But please, have a talk with Jean-Christophe first.

Best Regards,

Boris

> There is no sharing of identifiers across SoCs here, you just move the
> data around, and changing the .dts files to use the abstract macros would
> just end up making them harder to understand, not easier, since you then
> have to look up the numbers in another file.
>
> 	Arnd

