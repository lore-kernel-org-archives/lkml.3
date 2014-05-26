Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaEZQ6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:58:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38658 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751359AbaEZQ6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:58:03 -0400
Message-ID: <53837298.5080705@free-electrons.com>
Date: Mon, 26 May 2014 18:58:00 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dev@linux-sunxi.org
Subject: Re: [PATCH v2 5/5] regulator: axp20x: resolve self dependency issue
References: <1401116292-24066-1-git-send-email-boris.brezillon@free-electrons.com> <1401116292-24066-6-git-send-email-boris.brezillon@free-electrons.com> <20140526154356.GZ22111@sirena.org.uk>
In-Reply-To: <20140526154356.GZ22111@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 26/05/2014 17:43, Mark Brown wrote:
> On Mon, May 26, 2014 at 04:58:12PM +0200, Boris BREZILLON wrote:
>> Some regulators might take their power supply from other regulators defined
>> by the same PMIC.
>>
>> Retry regulators registration until all regulators are registered or the
>> last iteration didn't manage to register any new regulator (which means
>> there's an external dependency missing and we can thus return
>> EPROBE_DEFER).
> This is going to apply to most PMICs - we should factor this out into
> the core rather than implementing it individual drivers.  It works
> normally because typically the dependency is from DCDCs to LDOs and so
> with common naming schemes alphabetic sorting saves us.

I'm not sure I get what you mean.

AFAIU, we could factorize it by the mean of an helper function (say
devm_regulators_register), which would take a matches table and a
regulator desc table and do pretty much what I'm doing in this patch.

Is that what you had in mind ?

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

