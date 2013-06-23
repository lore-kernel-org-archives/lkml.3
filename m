Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3FWRdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 13:33:39 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57995 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3FWRde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 13:33:34 -0400
Message-ID: <51C73156.7040807@kernel.org>
Date: Sun, 23 Jun 2013 18:33:10 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, jimwall@q.com,
        brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCHv2 1/3] iio: Add Nuvoton NAU7802 ADC driver
References: <1371754675-12242-1-git-send-email-alexandre.belloni@free-electrons.com> <1371754675-12242-2-git-send-email-alexandre.belloni@free-electrons.com> <51C590B5.2060308@kernel.org> <51C5923D.6030609@metafoo.de> <51C5A1AF.3070404@free-electrons.com> <51C5A499.5050509@metafoo.de> <51C5A68F.3000300@free-electrons.com> <51C6FE00.8010900@metafoo.de>
In-Reply-To: <51C6FE00.8010900@metafoo.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 02:54 PM, Lars-Peter Clausen wrote:
> On 06/22/2013 03:28 PM, Alexandre Belloni wrote:
>> On 22/06/2013 15:20, Lars-Peter Clausen wrote:
>>> On 06/22/2013 03:07 PM, Alexandre Belloni wrote:
>>>> On 22/06/2013 14:02, Lars-Peter Clausen wrote:
>>>>> On 06/22/2013 01:55 PM, Jonathan Cameron wrote:
>>>>>> On 06/20/2013 07:57 PM, Alexandre Belloni wrote:
>>>>>>> The Nuvoton NAU7802 ADC is a 24-bit 2-channels I2C ADC, with adjustable
>>>>>>> gain and sampling rates.
>>>>>>>
>>>>>> Sorry, somewhat low on time today so only a quick review.
>>>>>>
>>>>>> 1) Missing userspace ABI documentation.  Also, perhaps min_conversions is
>>>>>>    a little vague?  Not that I have a better idea!
>>>>> I really don't like the name min_conversions either. Isn't this effectively
>>>>> a decimation filter?
>>>> Yeah, it could be seen like that but it is only relevant and only
>>>> happens when switching between channels. I'm open to any ideas.
>>>>
>>> I see. Is there anything about this in the datasheet on how many conversions
>>> you usually need? Is this really something you need to change at runtime or
>>> does moving this to platform data work?
>>>
>>>
>>
>> There is actually nothing in the datasheet. The default value (6
>> conversions) was found experimentally. What I did was saturating the ADC
>> with the higher value on one channel and the lower value on the other
>> one and I tried to find when reading both channel sequentially was
>> resulting in a correct value.
>>
>> You may not need to change it at runtime. And that value mainly depend
>> on the precision versus speed balance you want to achieve. If you know
>> that the values on both channels will not be to far apart, then you may
>> not need to wait at all.
>>
>> Would you think that is something I should hide in the DT ? Or maybe I
>> can drop that knob for now and see if it is needed in the future.
>>
> 
> It is always a good idea to be conservative when introducing new ABI, so if
> you think we can get away with hardcoding this in the driver I think that's
> a good idea.
> 
I agree entirely.  We can always make it controllable later as long
as we keep the default the same as the value you hard code in now.
