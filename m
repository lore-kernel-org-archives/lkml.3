Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761961Ab3EBSuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:50:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55329 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761824Ab3EBSuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:50:03 -0400
Message-ID: <5182B557.4040804@wwwdotorg.org>
Date: Thu, 02 May 2013 12:49:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com> <516EEAA0.10906@wwwdotorg.org> <20130418090310.GA17636@ab42.lan> <CACRpkdZd0_W432od5565phhUcJMRWiV9vXX4QVF4osKkxstC0Q@mail.gmail.com> <20130429161725.GB30136@ab42.lan>
In-Reply-To: <20130429161725.GB30136@ab42.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 10:17 AM, Christian Ruppert wrote:
> Hello Linus,
> 
> On Fri, Apr 26, 2013 at 09:47:16AM +0200, Linus Walleij wrote:
>> On Thu, Apr 18, 2013 at 11:03 AM, Christian Ruppert
>> <christian.ruppert@abilis.com> wrote:
>>
>>> We would like to avoid the use of Linux pin numbers in the device tree.
>>> Customers are used to physical pin numbers and exposing the logical
>>> Linux-internal numbering scheme through the device tree would generate
>>> quite some confusion. There are two reasons why we cannot align the two:
>>>   - Not all products supported by these drivers have the same pin outs.
>>>   - GPIO ranges must be consecutive in the Linux pin numbering space
>>>     which is generally not the case in physical pin numbering.
>>
>> If you are talking about the pin numbers really, i.e. the number we
>> put into
>>
>> struct pinctrl_pin_desc {
>>         unsigned number; <- this
>>         const char *name;
>> };
>>
>> Then are you aware that this is a sparse number space?
>>
>> I.e. you can choose whatever number you want. You do not have
>> to offset numbers from zero or anything like that. You just
>> need to make sure the numbers do not overlap (no two pins
>> have the same number).
>>
>> So if this is what you want to achieve, just use the same number
>> as in your datasheet in the pin number -> problem solved.
> 
> The problem is that we must support several products which are basically
> different packaging options of the same chip (or simplified versions
> thereof). Not all of those products will have the same number of pins
> and as a consequence, data sheet pin numbering will also be different.
> The port names are going to remain the same for all products, however.
> Some of the ports are just not going to be physically available in some
> or the products. Sorry if that wasn't clear from my previous mail.

It sounds like you can use the exact same numbering scheme for all the
different packaging options; it's just that some of the pin numbers
simply won't exist on some of the packaging options, so while defined by
the DT binding, it simply won't make sense to use them?

Certainly, Tegra20 has two packaging options, and the pinctrl driver for
it has zero knowledge of this. Perhaps we're just lucky though. I guess
the Tegra TRM doesn't define any "Pin number" (just "pin name") for the
pins, so there's no possibility of the same "number" meaning different
things in the two packages, so perhaps we're just getting lucky here.
