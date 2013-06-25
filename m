Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab3FYNvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:51:09 -0400
Received: from multi.imgtec.com ([194.200.65.239]:33919 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3FYNvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:51:06 -0400
Message-ID: <51C9A039.4090804@imgtec.com>
Date: Tue, 25 Jun 2013 14:50:49 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/4] pinctrl: remove slew-rate parameter from tz1090
References: <201306251455.01540.heiko@sntech.de> <201306251456.36499.heiko@sntech.de> <51C99581.2010403@imgtec.com> <201306251521.55634.heiko@sntech.de> <51C99AB5.1080002@imgtec.com> <CACRpkdbdwvmBYFX=ppdM_RmGwyTcWVeTCMj60F4sh6YEVRE2Uw@mail.gmail.com>
In-Reply-To: <CACRpkdbdwvmBYFX=ppdM_RmGwyTcWVeTCMj60F4sh6YEVRE2Uw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_25_14_50_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/13 14:32, Linus Walleij wrote:
> On Tue, Jun 25, 2013 at 3:27 PM, James Hogan <james.hogan@imgtec.com> wrote:
>> On 25/06/13 14:21, Heiko Stübner wrote:
> 
>>> My thoughts were that this code would never be reached when the parsing was
>>> removed and to not cause confusion to the driver when an acceptable binding
>>> was found for slew-rate.
>>>
>>> But it of course also doesn't hurt to stay in.
>>
>> Okay, fair enough.
>>
>> Acked-by: James Hogan <james.hogan@imgtec.com>
> 
> OK applied this so we have a clean slate.
> 
> Patches adding it back in with SI measures will be welcomed!

Okay.

So the most descriptive documentation I can find for the slew rate in
the TZ1090 pin config hardware is basically:

0: slow (half frequency)
1: fast

Sounds like this pretty much precludes it from having a generic DT
binding unless it can be mapped to some physical value, so I'll add a
tz1090,slew-rate and use PIN_CONFIG_END+1 instead of PIN_CONFIG_SLEW_RATE.

Anybody object to me adding an argument to
pinconf_generic_parse_dt_config() so that an additional
pinconf_generic_dt_params array can be optionally passed in? That way I
can share the generic pinconf dt parsing code.

Cheers
James

