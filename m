Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3J0UYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 16:24:11 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:58838 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3J0UYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 16:24:09 -0400
MIME-Version: 1.0
In-Reply-To: <20131027134607.E1782C4039D@trevor.secretlab.ca>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
	<1381869563-16083-10-git-send-email-grant.likely@linaro.org>
	<20131027134607.E1782C4039D@trevor.secretlab.ca>
Date: Sun, 27 Oct 2013 15:24:08 -0500
Message-ID: <CAL_JsqLN9eOWTo5pZV1m0i2GmxEMJWOcJvci_w=rCO7_h+X1Nw@mail.gmail.com>
Subject: Re: [RFC 9/9] of/irq: create interrupts-extended property
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 8:46 AM, Grant Likely <grant.likely@linaro.org> wrote:
> On Tue, 15 Oct 2013 21:39:23 +0100, Grant Likely <grant.likely@linaro.org> wrote:
>> The standard interrupts property in device tree can only handle
>> interrupts coming from a single interrupt parent. If a device is wired
>> to multiple interrupt controllers, then it needs to be attached to a
>> node with an interrupt-map property to demux the interrupt specifiers
>> which is confusing. It would be a lot easier if there was a form of the
>> interrupts property that allows for a separate interrupt phandle for
>> each interrupt specifier.
>>
>> This patch does exactly that by creating a new interrupts-extended
>> property which reuses the phandle+arguments pattern used by GPIOs and
>> other core bindings.
>>
>> Signed-off-by: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>
> Alright, I want to merge this one. I've got an Ack from Tony, general
> agreement from an in person converstaion from Ben (aside from wishing he
> could think of a better property name), and various rumblings of
> approval from anyone I talked to about it at ksummit. I'd like to have
> something more that that to put into the commit text. Please take a look
> and let me know if you agree/disagree with this binding.

I think it looks fine, but I'll throw out an alternative proposal.
Simply allow for interrupt-parent to be an array in equal size to
interrupts property. Then it is a minimal change to the existing
binding:

interrupt-parent = <&intc1>, <&intc2>;
interrupts = <5 0>, <6 0>;

Of course interrupts-extended is more inline with standard patterns
for bindings.

Rob
