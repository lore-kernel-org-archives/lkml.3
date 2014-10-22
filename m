Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbaJVXxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:53:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51909 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbaJVXxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:53:17 -0400
Message-ID: <5448436B.3020705@codeaurora.org>
Date: Wed, 22 Oct 2014 16:53:15 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Rob Herring <rob.herring@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] RFC: add function for localbus address
References: <20140729234522.E9FF1C40738@trevor.secretlab.ca> <1409672700-21697-1-git-send-email-svarbanov@mm-sol.com> <20140908145204.8ADC2C40AE5@trevor.secretlab.ca> <540E1014.8090102@codeaurora.org> <20140914044610.913E9C4102A@trevor.secretlab.ca> <54483746.9060104@codeaurora.org> <20141022232021.GF27405@n2100.arm.linux.org.uk>
In-Reply-To: <20141022232021.GF27405@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 04:20 PM, Russell King - ARM Linux wrote:
> On Wed, Oct 22, 2014 at 04:01:26PM -0700, Stephen Boyd wrote:
>> Where did this end up? When we talked at Connect I think we settled on
>> exploring a driver core specific API like dev_get_localbus_address()
>> that calls of_get_localbus_address() for devices with an of_node and in
>> the future it could call something like acpi_get_localbus_address() when
>> there's an acpi_node. I believe the biggest concern is that we're making
>> an API that is OF or platform bus specific when it doesn't need to be.
>> Making a driver core specific API avoids this problem by making it bus
>> agnostic.
> Given how little information there is in the original patch as to exactly
> what problem this is addressing, I could be getting the wrong end of the
> stick here.
>
> Is this about trying to have a way to obtain the bus local addresses
> associated with CPU-view resources?
>
> If so, how about looking towards PCI, which has had this problem for the
> last 15+ years, where PCI bus addresses are not necessarily the same as
> CPU physical addresses?
>
> There, we don't end up with multiple addresses specified in resources.
> We instead have a way to translate between resources and bus-local
> addresses, which IMHO is far nicer and less error-prone than having to
> specify the same information twice, once with an offset and once without.
>

Not really. This is about giving the address of a sub device on a pmic
to a platform driver for that sub device. There is no CPU view. The
addresses are offsets in a register space for a PMIC or other MFD that
lives on i2c/spi or some similar sort of bus. So perhaps 0x20
corresponds to the start of the register space for an RTC and 0x38
corresponds to the start of the register space for a regulator.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

