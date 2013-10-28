Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3J1VzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:55:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57680 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab3J1VzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:55:14 -0400
Message-ID: <526EDB80.7080406@wwwdotorg.org>
Date: Mon, 28 Oct 2013 15:47:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Rob Herring <rob.herring@calxeda.com>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC 9/9] of/irq: create interrupts-extended property
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org> <1381869563-16083-10-git-send-email-grant.likely@linaro.org> <20131027134607.E1782C4039D@trevor.secretlab.ca>
In-Reply-To: <20131027134607.E1782C4039D@trevor.secretlab.ca>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2013 07:46 AM, Grant Likely wrote:
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

The new binding makes sense to me. So, the binding,
Acked-by: Stephen Warren <swarren@nvidia.com>

A couple of minor perhaps bikesheddy comments below.

>> diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt

>> +Nodes that describe devices which generate interrupts must contain an either an
>> +"interrupts" property or an "interrupts-extended" property. These properties

"interrupts-ex" would be shorter, although I guess slightly harder to
guess its purpose, unless you're familiar with "ex" in symbol names.

...
>> +A device node may contain either "interrupts" or "interrupts-extended", but not
>> +both. If both properties are present, then the operating system should log an
>> +error

That sounds rather like prescribing SW behaviour, which I thought DT
bindings shouldn't do?

>> and use only the data in "interrupts".

... so perhaps that's better phrased as:

A device node may contain either "interrupts" or "interrupts-extended",
but not both. If both properties are present, the data in "interrupts"
takes precedence.
