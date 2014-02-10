Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaBJQiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:38:15 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:37951 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaBJQiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:38:13 -0500
Message-ID: <52F90071.4080604@codethink.co.uk>
Date: Mon, 10 Feb 2014 16:38:09 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Dave Martin <Dave.Martin@arm.com>
CC: linux@arm.linux.org.uk, jonathan.austin@arm.com, nico@linaro.org,
        marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, vgupta@synopsys.com,
        u.kleine-koenig@pengutronix.de,
        Fabrice GASNIER <fabrice.gasnier@st.com>, sboyd@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, maxime.coquelin@st.com
Subject: Re: [RFC PATCH] ARM: Add imprecise abort enable/disable macro
References: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com> <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com> <20140210141634.GA2794@e103592.cambridge.arm.com> <52F8E81E.70804@codethink.co.uk> <20140210152147.GE2794@e103592.cambridge.arm.com>
In-Reply-To: <20140210152147.GE2794@e103592.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/14 15:21, Dave Martin wrote:
> On Mon, Feb 10, 2014 at 02:54:22PM +0000, Ben Dooks wrote:
>> On 10/02/14 14:16, Dave Martin wrote:
>>> On Fri, Feb 07, 2014 at 05:19:15PM +0100, Fabrice GASNIER wrote:
>>>> This patch adds imprecise abort enable/disable macros.
>>>> It also enables imprecise aborts when starting kernel.
>>>
>>> Relying on imprecise aborts for hardware probing would be considered bad
>>> hardware and/or software design for ARM-specific stuff.
>>>
>>> PCI is more generic though, so we may have to put up with this to some
>>> extent.  Can you point me to the affected probing code?  I'm not very
>>> familiar with that stuff...
>>
>> The marvell pcie always had the option of delivering any bus
>> errors as imprecise aborts. However it was /annoying/ and therefore
>
> You don't say ;)
>
>> easier just to turn it off and rely on the hardware returning 0xffff
>> for any configuration area it couldn't get to.
>
> Does PCI have any way of finding out which parts of the configuration
> space are there before you are forced to go poking around in invalid
> address space?
>
> I'm guessing there may not be, otherwise this convsersation might not
> be happening ... but I don't know too much about PCI.

IIRC for configuration accesses you have to wait for the PCIe core
to get a response from the other end. The systems I've seen either
poll for completion or hold the transaction until the pcie core has
finished working.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
