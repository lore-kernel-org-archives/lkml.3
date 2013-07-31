Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907Ab3GaWQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:16:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52144 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab3GaWQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:16:32 -0400
Message-ID: <51F98CBC.6000302@wwwdotorg.org>
Date: Wed, 31 Jul 2013 16:16:28 -0600
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
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com> <1375180329-4860-3-git-send-email-richard.genoud@gmail.com> <51F7FBA8.6080400@wwwdotorg.org> <20130730204511.GX9858@sirena.org.uk> <51F8302D.406@wwwdotorg.org> <20130730225845.GB9858@sirena.org.uk>
In-Reply-To: <20130730225845.GB9858@sirena.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 04:58 PM, Mark Brown wrote:
> On Tue, Jul 30, 2013 at 03:29:17PM -0600, Stephen Warren wrote:
>> On 07/30/2013 02:45 PM, Mark Brown wrote:
> 
>>> You really shouldn't do this, it's not accomplishing much.
> 
>> What it accomplishes is not polluting the CODEC's binding with a
>> set of strings that must always be supported since DT is an ABI.
>> The strings are isolated into the specific audio complex binding,
>> which might possibly become deprecated and replaced with
>> something better and more generic.
> 
> You seem to be assuming that the strings are a bad thing.  I'm not
> sure that this is the case modulo the tooling issues...

I do tend to think that using strings is pretty evil...

> We could start adding the integers right now - something like:
> 
> The X CODEC has the following numbered input and output pins:
> 
> 1. HPOUTL 2. HPOUTR ...
> 
> (see datasheet for details), a header file is provided with 
> constants X_PIN_foo for convenience.
> 
> would work with either approach to identifying the pins or if
> we're being less verbose and just reference the header file for
> the definitions that becomes something like:
> 
> The X CODEC has input and output pins listed with numerical 
> identifiers in the form the X_PIN_foo defined in the X.h header 
> file where foo is the name of the pin.
> 
> (that's not good boilerplate wording but you get my drift) which
> still ends up defining a set of known strings for pins.
> 
> In fact now that I think about this why don't we just go ahead and
> do all this, starting by putting the numbers into the bindings for
> the CODECs since that's the simplest thing and doesn't involve
> writing code? I even have several boards on my desk that run DT
> ASoC...

I'm certainly fine with that compromise.
