Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaEMVcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:32:14 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:42422 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaEMVb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:31:59 -0400
Message-ID: <53728F4A.6050303@gmail.com>
Date: Tue, 13 May 2014 23:31:54 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [PATCH 1/2] clk: of: helper for determining flags properties
References: <1399982253-21079-1-git-send-email-gabriel.fernandez@linaro.org> <1399982253-21079-2-git-send-email-gabriel.fernandez@linaro.org> <20140513122054.GA2419@e106331-lin.cambridge.arm.com> <5372363B.4080608@gmail.com> <20140513204924.5943.24086@quantum>
In-Reply-To: <20140513204924.5943.24086@quantum>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 10:49 PM, Mike Turquette wrote:
> Quoting Sebastian Hesselbarth (2014-05-13 08:11:55)
>> On 05/13/2014 02:20 PM, Mark Rutland wrote:
>>> You've also failed to document the property.
>>>
>>> What are you trying to achieve here, and why do you think this is the
>>> best way of achieving that?
>>
>> I cannot tell from the commit msgs, but consider clk-si5351 which is a
>> driver for an external programmable clock with N PLLs and M outputs. Now
>> connect a video clock consumer and an audio clock consumer to two
>> different outputs and those to one PLL (as you want audio clock derived
>> from video clock, typical HDMI scenario).
>>
>> Now, there should be a way to tell the generic driver which outputs are
>> allowed to change the PLLs rate and which don't. Otherwise, the clock
>> chip would be pretty useless as e.g. your audio clock consumer will
>> overwrite the rate the video clock consumer has chosen.
> 
> This is really a job for the "coordinated clock rate changes" that are
> currently in development. These specify clock sub-tree snapshots of
> parent and rate configurations that are predefined. These combinations
> can be specified in DT. That helps a lot with clock configurations that
> change per board, or for cases where many combinations of parents and
> dividers can yield the same output rate, but only a subset of those were
> validated by the silicon validation team or had proper timing closure so
> we don't want to rely on the "walk up the tree" algorithm.

Ah! Great to hear there is work on that already. Thanks for the heads
up!

Sebastian
