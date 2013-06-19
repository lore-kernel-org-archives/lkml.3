Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab3FSSUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:20:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52341 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3FSSUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:20:15 -0400
Message-ID: <51C1F42E.5090107@wwwdotorg.org>
Date: Wed, 19 Jun 2013 12:10:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/2] Make non-linear GPIO ranges accesible from gpiolib
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com> <1371128132-18266-2-git-send-email-christian.ruppert@abilis.com> <51BA3BC1.3090109@wwwdotorg.org> <20130614091241.GA23745@ab42.lan>
In-Reply-To: <20130614091241.GA23745@ab42.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 03:12 AM, Christian Ruppert wrote:
> On Thu, Jun 13, 2013 at 03:38:09PM -0600, Stephen Warren wrote:
>> On 06/13/2013 06:55 AM, Christian Ruppert wrote:
>>> This patch adds the infrastructure required to register non-linear gpio
>>> ranges through gpiolib and the standard GPIO device tree bindings.
>>
>> That's not exactly true. The existing gpio-ranges property already
>> allows non-linear ranges to be represented quite easily; each entry in
>> the gpio-ranges list is <gpio-base> <pinctrl-base> <count>, so you can
>> piece together any mapping you want.
> 
> You're right, my description is somewhat imprecise here.
> 
>> The potential advantage of this patch is that the pinctrl-side of the
>> mapping can be a group name rather than pin IDs, which might reduce the
>> size of the mapping list if you have an extremely sparse or non-linear
>> mapping /and/ parts of that mapping just happen to align with the pin
>> groups in the pin controller HW, since each entry in the gpio-ranges
>> property can be sparse/non-linear, rather than being a small linear
>> chunk of the mapping.
> 
> Pin controller authors have the freedom to define pin groups just for
> the purpose of "predefining" the pinctrl side of GPIO ranges.

Hmm. I suppose that's true. I'm not sure how enthusiastic I am about
doing this though... The reason I'm unsure is because it starts using
pin groups from something other than groups of pins in HW that are all
affected by the same mux or config bits in a register, and starts using
pin groups for something else; GPIO<->pinmux pins mapping. Perhaps it's
OK though, considering the other abuses of pin groups that are already
present, such as using pin groups to represent default/common uses of
groups of pins that don't actually exist in HW.
