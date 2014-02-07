Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaBGIPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:15:36 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:34765 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbaBGIPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:15:34 -0500
Message-ID: <52F49461.2020008@st.com>
Date: Fri, 7 Feb 2014 08:08:01 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, <kernel@stlinux.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        <linux-kernel@vger.kernel.org>, Stuart Menefy <stuart.menefy@st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, <maxime.coquelin@st.com>,
        <alexandre.torgue@st.com>
Subject: Re: [PATCH 1/4] ARM: STi: add stid127 soc support
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com> <201401312115.33731.arnd@arndb.de> <52F22508.7080706@st.com> <201402061746.30248.arnd@arndb.de>
In-Reply-To: <201402061746.30248.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/14 16:46, Arnd Bergmann wrote:
> On Wednesday 05 February 2014, srinivas kandagatla wrote:
>> Currently l2cc bindings has few optional properties like.
>>
>> - arm,data-latency
>> - arm,tag-latency
>> - arm,dirty-latency
>> - arm,filter-ranges
>> - interrupts :
>> - cache-id-part:
>> - wt-override:
>>
>> These does not include properties to set "way-size", "associativity",
>> "enabling prefetching", "Prefetch drop enable", "prefetch offset",
>> "Double linefill" and few more in prefect control register and
>> aux-control register.
>>
>> This is not just a issue with STi SOCs, having a quick look, I can see
>> that few more SOCs have similar requirements to set these properties.
>>
>> We could do two things to get l2 setup automatically on STi SOCS.
>>
>> 1> Either define these properties case-by-case basic, which might be
>> useful for other SOCs too.
>>
>> 2> Or Add new compatible string for STi SoCs so that they can
>> automatically setup these values in cache-l2x0.c
>>
>> Am Ok with either approaches.
>>
> 
> I suggested 1 in the past, but the objection that I saw (can't
> find the email at the moment) was that the additional settings
> are "configuration" rather than "hardware properties". What I'd
> really need to know from you is which of properties you listed
> as missing above are actually needed for your platform, and whether
> they can be classified as hardware specific or just configuration.

On STi Platforms we need below properties to got for option 1.
arm,way-size;
arm,instruction-prefetch-enable;
arm,data-prefetch-enable;

we also want a property or a way to set
"Shareable attribute Override Enable" bit in the Auxiliary Control
Register, bit[22].

Thanks,
srini
> 
> 	Arnd
> 
> 

