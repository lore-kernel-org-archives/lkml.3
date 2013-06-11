Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3FKLk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:40:56 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:37035 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151Ab3FKLky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:40:54 -0400
Message-ID: <51B70BB1.6040703@st.com>
Date: Tue, 11 Jun 2013 12:36:17 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-doc@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, linux@arm.linux.org.uk,
        Samuel Ortiz <sameo@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        linux-serial@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 03/11] regmap: Add regmap_field APIs
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com> <1370856118-6503-1-git-send-email-srinivas.kandagatla@st.com> <20130611104841.GX1403@sirena.org.uk>
In-Reply-To: <20130611104841.GX1403@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/13 11:48, Mark Brown wrote:
> On Mon, Jun 10, 2013 at 10:21:58AM +0100, Srinivas KANDAGATLA wrote:
>> It is common to access regmap registers at bit level, using
>> regmap_update_bits or regmap_read functions, however the end user has to
>> take care of a mask or shifting. This becomes overhead when such use
>> cases are high. Having a common function to do this is much convenient
>> and less error prone.
> 
> So this looks basically good.  A couple of smallish nits below, if you
> could respin I'll apply this on a branch so it can be pulled in as
> dependency for the other things that use it.
> 
Thankyou for the comments,
I will fix it and send a v3 patch.

>> +	regmap_field_init(rm_field, regmap, reg_field);
>> +
>> +	return rm_field;
>> +
>> +}
>> +EXPORT_SYMBOL_GPL(devm_regmap_field_alloc);
>> +/**
>> + * regmap_field_alloc(): Allocate and initialise a register field
> 
> Needs a blank line between the two functions.
> 
>> +#include <linux/device.h>
>> +#include <linux/slab.h>
> 
>> +static inline void regmap_field_free(struct regmap_field *field)
>> +{
>> +	kfree(field);
>> +}
> 
>> +static inline void devm_regmap_field_free(struct device *dev,
>> +	struct regmap_field *field)
>> +{
>> +	devm_kfree(dev, field);
>> +}
> 
> Probably not worth inlining these, just put them in the code.
> 
> 
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 

