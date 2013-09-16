Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3IPQl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:41:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35509 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab3IPQl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:41:27 -0400
Message-ID: <523734B2.6050208@wwwdotorg.org>
Date: Mon, 16 Sep 2013 10:41:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH alt 4/4] pinctrl: at91: rework debounce configuration
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com> <1379058813-3489-1-git-send-email-b.brezillon@overkiz.com> <52339479.6030402@wwwdotorg.org> <52340B68.5020505@overkiz.com>
In-Reply-To: <52340B68.5020505@overkiz.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2013 01:08 AM, boris brezillon wrote:
> Hello Stephen,
> 
> Le 14/09/2013 00:40, Stephen Warren a écrit :
>> On 09/13/2013 01:53 AM, Boris BREZILLON wrote:
>>> AT91 SoCs do not support per pin debounce time configuration.
>>> Instead you have to configure a debounce time which will be used for all
>>> pins of a given bank (PIOA, PIOB, ...).
...
>>>   Required properties for pin configuration node:
...
>>> -DEBOUNCE_VAL    (0x3fff << 17): debounce val.
>>
>> This change would break the DT ABI since it removes a feature that's
>> already present.
...
>> I suppose it's still up to the Atmel maintainers to decide whether this
>> is appropriate, or whether the impact to out-of-tree DT files would be
>> problematic.
>>
>> Assuming the DT ABI can be broken, I think I'd prefer to do so, rather
>> than take "non-alt" patch 4/4, since a per-pin DEBOUNCE_VAL clearly
>> doesn't correctly model the HW, assuming the patch description is
>> correct. I don't think arguments re: the generic pinconf debounce
>> property hold; if the Linux-specific/internal generic property doesn't
>> apply, the DT binding should not be bent to adjust to it, but should
>> rather still represent the HW itself.
> 
> What about the last point in my list: "reconfigure debounce after
> startup" ?
> 
> Here is an example that may be problematic:
> 
> Let's say you have one device using multiple configuration of pins
> ("default", "xxx", "yyy").
> The "default" config needs a particular debounce time on a given pin and
> the "xxx" and "yyy"
> configs need different debounce time on the same pin.
> 
> How would you solve this with this patch approach ?

Each state has a different pin configuration node, and hence can specify
a different debounce value. This patch has no impact on that (it just
changes whether the state-specific node specifies the debounce value in
a single standalone property, or encodes it into each entry in the pins
property, all within the same node).
