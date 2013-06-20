Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965617Ab3FTT07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:26:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54886 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965026Ab3FTT05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:26:57 -0400
Message-ID: <51C3577E.6040709@wwwdotorg.org>
Date: Thu, 20 Jun 2013 13:26:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] pinctrl: document the pinctrl PM states
References: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com> <51BA1FE7.4000900@wwwdotorg.org> <CACRpkdZV7R3MgbuvEMhs24YYv2hK8Kt9Kjmv_cpRQQ1NYviDQg@mail.gmail.com> <51BB3A2C.608@wwwdotorg.org> <20130617072021.GB4465@atomide.com> <51C20E3A.8090304@wwwdotorg.org> <20130620063823.GD5523@atomide.com>
In-Reply-To: <20130620063823.GD5523@atomide.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 12:38 AM, Tony Lindgren wrote:
> * Stephen Warren <swarren@wwwdotorg.org> [130619 13:08]:
>> On 06/17/2013 01:20 AM, Tony Lindgren wrote:
...
>>> Below are the pin remuxing cases I'm aware of:
>> ...
>>> Then for dealing with the above examples, I think we already have a
>>> pretty good setup in pinctrl framework to deal with this with the
>>> named modes. But I think that to do this properly with the named
>>> modes we should have named modes like the following:
>>>
>>> "static" && ("active" || "idle")
>>> "static" && ("rx" || "tx")
>>>
>>> Here the "static" pins would be set during driver probe and never
>>> need to change until the driver is unloaded. This is close to what we
>>> currently call "default". But we should probably make it clear that
>>> these will not change to avoid confusion. See below for more info.
>>>
>>> The the non-static states like "active"/"idle", or "rx"/"tx", can
>>> be set in addition to "static", but they should not be subsets of
>>> "static" to avoid the issues Stephen described earlier. This way we
>>> allow the named modes to do the work for us while protecting the
>>> claimed pins.
>>
>> Yes, I think this can certainly work conceptually. It's equivalent to
>> pre-computing which parts of the overall state don't change between the
>> currently-defined "global" active/idle states and then applying the
>> diffs at runtime - rather like what I suggested before, but without the
>> pinctrl code having to do the diff at runtime. I'm not sure if I have
>> (yet) a strong opinion on whether allowing multiple states to be active
>> at once (i.e. static plus active) is the correct way to go. Maybe once
>> I've finished reading the thread...
> 
> I don't think there's any issue for having multiple sets active the same
> is an issue, we're already doing it quite a bit although for different
> device drivers so we have the framework ready for that already.

I assume you mean there shouldn't be any issue *modifying* the pinctrl
API to allow multiple states to be active at once? And where you're
talking about having multiple sets active at once already, you're
talking about some other API?

Right now, pinctrl_select_state() de-activates the old state while
activating the new state, so it's not possible to have more than one
active at once.
