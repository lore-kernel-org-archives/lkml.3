Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3HTGLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:11:40 -0400
Received: from 14.mo6.mail-out.ovh.net ([46.105.56.113]:38639 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751973Ab3HTGLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:11:39 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Aug 2013 08:11:37 +0200
From: <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
X-Ovh-Mailout: 178.32.228.6 (mo6.mail-out.ovh.net)
Subject: Re: [PATCH 1/8] ARM: at91: move peripheral id definitions to
 dt-bindings include dir
In-Reply-To: <52124BD5.5060801@atmel.com>
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
 <1375339933-3643-1-git-send-email-b.brezillon@overkiz.com>
 <201308072224.30614.arnd@arndb.de> <520319DE.5090100@overkiz.com>
 <52124BD5.5060801@atmel.com>
Message-ID: <37721084ba1145097fc0dcbb8d74acb7@localhost>
User-Agent: RoundCube Webmail/0.4
X-Ovh-Tracer-Id: 619526424385976428
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrfeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nicolas,

On Mon, 19 Aug 2013 18:46:13 +0200, Nicolas Ferre
<nicolas.ferre@atmel.com> wrote:
> On 08/08/2013 06:09, boris brezillon :
>> Hello Arnd,
>>
>> On 07/08/2013 22:24, Arnd Bergmann wrote:
>>> On Thursday 01 August 2013, Boris BREZILLON wrote:
>>>> This patch moves peripheral id definitions from machine specific include
>>>> dir (arch/arm/mach-at91/include/mach/'soc-name'.h) to dt-bindinds include
>>>> dir (include/dt-bindings/at91/'soc-name'/peripherals.h).
>>>>
>>>> These definitions will be used inside dt to define interrupt ids and
>>>> peripheral clk ids.
>>>>
>>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>> This seems counterproductive, why would you do that?
>>
>> This was requested by Jean-Christophe Plagniol-Villard (and proposed by
>> Richard Genoud)
>> for the 3rd version of the "ARM: at91: move to common clk framework"
>> patch series (see
>> https://lkml.org/lkml/2013/7/29/361) and thought it was a good idea too
>> (even if I didn't know
>> where to put the macro files as there are no soc specific macro files in
>> dt-bindings include
>> dir).
>>
>> Indeed I found it much easier to detect bugs in dt definition using
>> macros because
>> the macro names and dt node names are the same (it does not protect
>> against errors
>> in the macro definitions).
>>
>> If you think these macro definitions should be dropped, I won't argue
>> against this.
>> But please, have a talk with Jean-Christophe first.
> 
> [..]
> 
>>> There is no sharing of identifiers across SoCs here, you just move the
>>> data around, and changing the .dts files to use the abstract macros would
>>> just end up making them harder to understand, not easier, since you then
>>> have to look up the numbers in another file.
> 
> Boris, Jean-Christophe and Richard,
> 
> Well, I must say that I do agree with Arnd on this point.
> 
> I think that a simple numeric field in a cell has to be represented
> as a number and even if this simple information is used twice
> (interrupt number and clock bit position in PMC). The possibility of
> error is very low compared to the big amount of unneeded definitions
> added by this solution.
> 
> Moreover, I had the hope to completely remove this long list of
> peripheral definitions for all SoC when we have a full DT kernel (with
> your patches about common clock framework). So I think it is not
> interesting to move in this direction and continue to build such a
> list for future full DT products...
> 
> Believe me, I am sorry that I didn't entered the discussion earlier
> and avoid unnecessary work... Anyway, give me your opinion, but I do
> think that the simpler is the best.
> 

As discussed with you (on IRC), I am not absolutely convinced we need
these macro definitions, and given the direction you want to take
(completely
remove the peripheral id definitions), i would say we'd rather drop
this patch.
It won't bother me at all to rework the "sama5 dt clk" patch series
(this is the
only SoC I supported in the 3rd version of the at91 common clk
transition)
to remove references to these macros.

Best Regards,
Boris

> Bye,

