Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab3EIOGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:06:31 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:52996 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562Ab3EIOG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:06:29 -0400
Message-ID: <518BABF0.7040201@st.com>
Date: Thu, 09 May 2013 15:00:16 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, dong.aisheng@linaro.org,
        sameo@linux.intel.com, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Stuart Menefy <stuart.menefy@st.com>,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <1368022272-2241-1-git-send-email-srinivas.kandagatla@st.com> <201305081650.23264.arnd@arndb.de> <20130508150141.GA5057@opensource.wolfsonmicro.com> <518A8E6C.6070907@st.com> <20130509095143.GB7478@sirena.org.uk> <518B8F49.5020902@st.com> <20130509132600.GA3200@sirena.org.uk>
In-Reply-To: <20130509132600.GA3200@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/13 14:26, Mark Brown wrote:
> On Thu, May 09, 2013 at 12:58:01PM +0100, Srinivas KANDAGATLA wrote:
> 
>> Currently, we have two bits of information which come from device trees.
>> 1> The syscon bank/group definition itself.
>> 2> syscon register offsets and bits information to the drivers.
> 
>> These are the 2 things which keep changing per each SOC.
> 
>> There is no other way to pass this information to the drivers other than
>> passing them as part of their own device node and syscon node.
> 
> Sure there is, for example the drivers could have this information
> internally as part of knowing which device they're working with or they
> could take advantage of some patterns in the register map to store some
> higher level information that they use to configure.
> 
Some of layouts of the sysconf registers are totally changed for each SOC.

Looking at driver by driver maybe some drivers can take advantage of the
patterns, but Am not sure if this will be a sustainable solution for all
the drivers.

The big disadvantage of this approach is that
- Every driver has to be touched for new SOC,
- Secondly the drivers will end up having more of such information than
code over a time.

>>>  and to the extent that it is sensible it feels like something
>>> which might be useful with any device using register maps, not just
>>> syscon.
> 
>> If you think this is going to be useful for other drivers, Am happy to
>> move this out of syscon to regmap something like adding
>> of_regmap_field_claim/regmap_field_claim/regmap_field_read/regmap_field_write/regmap_field_release
>> functions.
> 
>> so any exiting drivers can still use the old syscon API to get the
>> regmap instance.
>> Alternatively they can use the new regmap APIs directly.
> 
> Well, I'd need to see the code to decide if it was sane but I do think
> that if this is a good approach it's not syscon specific.  Anything like
> this needs to be independent of DT too since not all architectures use
> DT.
In the suggested approach, the API supports, both DT and non-DT style.

for DT style user can use.
of_regmap_field_claim -> regmap_field_read -> regmap_field_write-
->regmap_field_release

and for NON-DT user can use
regmap_field_claim  -> regmap_field_read -> regmap_field_write-
->regmap_field_release


thanks,
srini


> 

