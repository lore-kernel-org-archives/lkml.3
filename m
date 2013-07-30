Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab3G3V3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 17:29:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38511 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab3G3V3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 17:29:21 -0400
Message-ID: <51F8302D.406@wwwdotorg.org>
Date: Tue, 30 Jul 2013 15:29:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Richard Genoud <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH v6 2/8] ASoC: atmel: machine driver for at91sam9x5-wm8731
 boards
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com> <1375180329-4860-3-git-send-email-richard.genoud@gmail.com> <51F7FBA8.6080400@wwwdotorg.org> <20130730204511.GX9858@sirena.org.uk>
In-Reply-To: <20130730204511.GX9858@sirena.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 02:45 PM, Mark Brown wrote:
> On Tue, Jul 30, 2013 at 11:45:12AM -0600, Stephen Warren wrote:
>> On 07/30/2013 04:32 AM, Richard Genoud wrote:
> 
>>> +wm8731 pins: +cf
>>> Documentation/devicetree/bindings/sound/wm8731.txt
> 
>> In the Tegra bindings, I deliberately put the list of CODEC pins
>> into the audio complex binding rather than the CODEC binding.
>> That's because
> 
> You really shouldn't do this, it's not accomplishing much.

What it accomplishes is not polluting the CODEC's binding with a set
of strings that must always be supported since DT is an ABI. The
strings are isolated into the specific audio complex binding, which
might possibly become deprecated and replaced with something better
and more generic.

>> I'm not sure that in the long-term we want to use strings to
>> identify the CODEC pins, rather than using integers. By putting
>> the list orf CODEC pins in the audio complex binding rather than
>> the CODEC binding, I didn't lumber the CODEC binding with a list
>> of strings that it had to support forever.
> 
> How would you create the numbers - you can't use the pin numbers
> since BGA type packages have alphanumeric ball identifiers?

The numbering would be arbitrary, except perhaps for packages that had
simple numeric pin IDs in which case those could be used. There would
be a file in <dt-bindings/audio/...> that defined it, which DTs would
include to create the properties, and CODEC/... drivers would include
and use whenever it needed to identify the pins, e.g. in some kind of
.of_xlate() function.

> Even with numerical pin numbering ou'd need to specify some defines
> for this not to be totally awful at which point you may as well
> have the strings documented since you'd end up writing a table in
> the binding document that's basically a mapping of pin names to
> numbers,
> 
>> One reason that strings are problematic is because they can't be
>> mixed with integers/phandles in the same property, so if we ever
>> end up with more generic audio bindings where the routing table
>> is expressed more like:
> 
>> audio-routes = <&component_a $a_pin &component_b $b_pin>;
> 
>> ... in order to allow completely arbitrary and fully name-spaced
>> routing specification[1], then $a_pin and $b_pin need to be
>> integers not strings.
> 
> The above is going to be legibility challenged without defines at
> which point the strings end up appearing in the binding document
> anyway.

Yes, you'd certainly have to use defines not raw integers. The strings
wouldn't appear in the binding doc so much as the numbers.
