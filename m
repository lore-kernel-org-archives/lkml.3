Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3FTHMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:12:21 -0400
Received: from 6.mo3.mail-out.ovh.net ([188.165.43.173]:42394 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753971Ab3FTHMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:12:20 -0400
Message-ID: <51C2AB50.6060104@overkiz.com>
Date: Thu, 20 Jun 2013 09:12:16 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC PATCH 13/50] ARM: at91: move at91rm9200 SoC to new at91
 clk implem
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com> <1370617863-18410-1-git-send-email-b.brezillon@overkiz.com> <20130620065258.9136.63631@quantum>
In-Reply-To: <20130620065258.9136.63631@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12355907053182547996
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 20/06/2013 08:52, Mike Turquette wrote:
> Quoting Boris BREZILLON (2013-06-07 08:11:03)
>> +static struct clk_lookup pioA_clk_lookup[] = {
>> +       CLKDEV_INIT(NULL, "pioA_clk", NULL),
>> +       CLKDEV_INIT(NULL, "pioA", NULL),
>> +};
> It would be great to get rid of this clkdev data from the kernel as
> well. Have you looked into encoding the aliases into your DT bindings?
I already switched all dt boards to dt clk definition (see patch 36 to 50).
These definition are kept for all non-dt boards (see in 
arch/arm/mach-at91/board-xxx.c).
This will be cleaned as soon as all non-dt boards are moved to dt.
>
> Or have you looked into using of_clk_get?
If I remember correctly, the clk_get function first tries to get the clk 
from dt binding.
Then if it fails it uses the clk_lookup info. Am I right ?
If so, I don't need to use of_clk_get in drivers calling clk_get with a 
non NULL device
parameter.

The only place where I use of_clk_get is in init timer driver 
(at91sam926x_time.c).
I first try to retrieve the clk from dt, then if it fails (or if dt is 
not supported),
I use clk_get with a NULL device param, which will lead to clk_lookup 
search.


Tell me if I misunderstood the API.
>
> Regards,
> Mike

Best Regards,
Boris
