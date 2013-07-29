Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab3G2QAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:00:31 -0400
Received: from 19.mo5.mail-out.ovh.net ([46.105.35.78]:48272 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752113Ab3G2QA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:00:29 -0400
Message-ID: <51F68FB0.4090507@overkiz.com>
Date: Mon, 29 Jul 2013 17:52:16 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH] pinctrl: at91: choose appropriate handler for level interrupts
References: <1374331893-16009-1-git-send-email-b.brezillon@overkiz.com> <CACRpkdaGdgLeYrahv0qAJJjL3S2aiZeVwRVUtNcDqQgL3_mQkA@mail.gmail.com>
In-Reply-To: <CACRpkdaGdgLeYrahv0qAJJjL3S2aiZeVwRVUtNcDqQgL3_mQkA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 10349271944050800861
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/2013 17:42, Linus Walleij wrote:
> On Sat, Jul 20, 2013 at 4:51 PM, Boris BREZILLON
> <b.brezillon@overkiz.com> wrote:
>
>> The current implementation handle both edge and level interrupts with the
>> 'handle_simple_irq' handler.
>>
>> Level interrupts are active as long as the pin stays at the configured
>> level (low or high). In this case we have to use 'handle_level_irq' which
>> mask the interrupt until the handle has treated it.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Nicolas/Jean-Christophe: any opinion on this patch?
>
> I am tempted to just apply it and see if you react to it :-)
Hello,

Just for clarification, without this patch the kernel hangs if you request a
threaded irq on level state (low or high).

This was tested on sama5ek board.

Best Regards,

Boris
>
> Yours,
> Linus Walleij

