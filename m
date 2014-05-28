Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaE1TrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:47:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47054 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751756AbaE1TrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:47:08 -0400
Message-ID: <53863D2E.7050008@free-electrons.com>
Date: Wed, 28 May 2014 21:46:54 +0200
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
Subject: Re: [PATCH v3 0/6] mfd: axp20x: add AXP221 PMIC support
References: <1401183535-31003-1-git-send-email-boris.brezillon@free-electrons.com> <20140527194932.GD12304@sirena.org.uk>
In-Reply-To: <20140527194932.GD12304@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Mark,

On 27/05/2014 21:49, Mark Brown wrote:
> On Tue, May 27, 2014 at 11:38:49AM +0200, Boris BREZILLON wrote:
>
>> I'm still waiting for inputs regarding the ipsout regulator representation:
> If you've got questions you need an answer to urgently it's possibly
> best to highlight them outside of a series like this doing that helps
> make it more obvious.

Noted. I'll take care to send a separate mail next time.

BTW, I don't if you've noticed, but patch 5 of this series implements
helper functions to register several regulators from a regulator_desc
and an of_regulator_match table (as you suggested).

>>  * The ipsout regulator is currently represented as a fixed regulator
>>    providing a 5v output, and this is not exactly the case.
>>    AFAIU (here's is the datasheet traduction if you want to check [1]), the
>>    ipsout output is a multiplexer that choose among vbus (5V), acin (12V
>>    which is then converted to 5V) and the battery power supply (3,5 -> 4,2 V).
>>    This means the output voltage of ipsout vary between 3,5V and 5V.
>>    How can we express this kind of muxer in the regulator framework (is there
>>    already something available ?) ?
>>    Note that the power supply selection is automatic, though we could force
>>    one power supply, but then we loose the ability to unplug one power supply
>>    without impacting the system.
> This sounds like it may as well just be represented as an unregulated
> supply - it's just the system root supply really.  Nothing can rely on
> the voltage anyway as it's going to vary randomly depending on what the
> user does power wise and typically it'd only be used as a supply for
> things that don't care about the specific voltage.

Okay, I'm fine with that.

Thanks.

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

