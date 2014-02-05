Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaBELzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 06:55:50 -0500
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:37995 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbaBELzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 06:55:48 -0500
Message-ID: <52F22508.7080706@st.com>
Date: Wed, 5 Feb 2014 11:48:24 +0000
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
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com> <201401301939.08302.arnd@arndb.de> <52EB96BB.6070800@st.com> <201401312115.33731.arnd@arndb.de>
In-Reply-To: <201401312115.33731.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
On 31/01/14 20:15, Arnd Bergmann wrote:
> On Friday 31 January 2014, srinivas kandagatla wrote:
> 
>>> Sorry if I missed the initial review, but can you explain
>>> why this is needed to start with?
>>
>> On ST SoCs the default value for L2 AUX_CTRL register is 0x0, so we  set
>> the way-size explicit here.
> 
> Unfortunately, we keep going back and forth on the L2 cache controller
> setup between "it should work automatically" and "we don't want to
> have configuration data in DT", where my personal opinion is that
> the first one is more important here.
> 
> Now, there are a couple of properties that are defined in
> Documentation/devicetree/bindings/arm/l2cc.txt to let some of the
> things get set up automatically already. Can you check which bits
> are missing there, if any? Are they better described as "configuration"
> or "hardware" settings?

Currently l2cc bindings has few optional properties like.

- arm,data-latency
- arm,tag-latency
- arm,dirty-latency
- arm,filter-ranges
- interrupts :
- cache-id-part:
- wt-override:

These does not include properties to set "way-size", "associativity",
"enabling prefetching", "Prefetch drop enable", "prefetch offset",
"Double linefill" and few more in prefect control register and
aux-control register.

This is not just a issue with STi SOCs, having a quick look, I can see
that few more SOCs have similar requirements to set these properties.

We could do two things to get l2 setup automatically on STi SOCS.

1> Either define these properties case-by-case basic, which might be
useful for other SOCs too.

2> Or Add new compatible string for STi SoCs so that they can
automatically setup these values in cache-l2x0.c

Am Ok with either approaches.


Thanks,
srini


> 
> 	Arnd
> 
> 

