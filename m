Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3JVVjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:39:00 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:39884 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3JVVi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:38:58 -0400
Message-ID: <5266F06C.2080701@gmail.com>
Date: Tue, 22 Oct 2013 16:38:52 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Matt Porter <matt.porter@linaro.org>,
        Matthijs Kooijman <matthijs@stdin.nl>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Does PHY UTMI data width belong to DWC2 or PHY binding?
References: <20131018141221.GH2721@beef> <5264F37E.9060307@ti.com> <20131022104829.GF15425@login.drsnuggles.stderr.nl> <20131022112520.GE29341@beef>
In-Reply-To: <20131022112520.GE29341@beef>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 06:25 AM, Matt Porter wrote:
> On Tue, Oct 22, 2013 at 12:48:29PM +0200, Matthijs Kooijman wrote:
>> Hi Kishon,
>>
>> On Mon, Oct 21, 2013 at 02:57:26PM +0530, Kishon Vijay Abraham I wrote:
>>> I think it makes sense to keep the data width property in the dwc2 node itself.
>>> I mean it describes how the dwc2 IP is configured in that particular SoC (given
>>> that it can be either <8> or <16>).
>> If I'm reading the RT3052 datasheet correctly (GHWCFG4 register), the IP
>> can be configured for 8, 16 or 8 _and_ 16. In the latter case, the "8
>> and 16 supported" would make sense as a property of dwc2 (though this
>> value should be autodetectable through GHWCFG4), while the actual 8 or
>> 16 supported by the PHY would make sense as property of a phy.
> 
> There would be no value in adding a property for an already detectable
> value to dwc2's binding. To be honest, it's pretty much useless
> information due to the existence of the "8 and 16" option.
> 
>> Note sure if this is really useful in practice as well, or if just
>> setting the actual width to use on dwc2 makes more sense...
> 
> The GHWCFG4 information itself is not useful in practice, as described
> in the original thread: https://lkml.org/lkml/2013/10/10/477
> 
> It's certainly useful in practice to have this width property in either
> the dwc2 or the phy binding. One can make a case for either. As I
> mentioned in the original post, if we put it in the phy binding we'll be
> updating the generic phy binding. We'll then need an api added into the
> generic phy framework to fetch the width of a phy.
> 
> Both cases are doable and trivial, we just need the canonical decision
> from a DT maintainer as to where the property belongs. Given that they
> are in ARM ksummit, I'm not expecting to hear anything right this
> moment. :)

The host can support both, so it is not a property of the host and is a
property of the phy. It is no different than what mode a SPI slave
requires or whether an i2c slave supports 8 or 10-bit addressing. Those
examples are all 1 to many rather than 1 to 1 where it doesn't really
matter, but the same logic applies.

Rob


