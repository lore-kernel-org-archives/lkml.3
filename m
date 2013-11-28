Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab3K1Fnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 00:43:37 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:47950 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781Ab3K1Fne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 00:43:34 -0500
Message-ID: <5296D7DF.202@st.com>
Date: Thu, 28 Nov 2013 11:12:55 +0530
From: Amit Virdi <amit.virdi@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "marc.ceeeee@gmail.com" <marc.ceeeee@gmail.com>,
        "spear--sw-devel@codex.cro.st.com" <spear--sw-devel@codex.cro.st.com>
Subject: Re: [PATCH] ARM: asm: Configure caches as per the defconfig
References: <1385553244-1513-1-git-send-email-amit.virdi@st.com> <20131127121425.GN16735@n2100.arm.linux.org.uk>
In-Reply-To: <20131127121425.GN16735@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 5:44 PM, Russell King - ARM Linux wrote:
> On Wed, Nov 27, 2013 at 05:24:04PM +0530, Amit Virdi wrote:
>> From: Amit VIRDI <Amit.VIRDI@st.com>
>>
>> In the current implementation of the decompression code, the caches are enabled
>> irrespective of their configuration in the deconfig. This makes setting the
>> ICACHE and DCACHE disable options from the menuconfig irrelevant. Change this
>> implementation to enable caches only if specified in the defconfig.
>
> NAK.  These options are provided more for ARM Ltd's validation of CPUs
> rather than for users, and it's not supposed to be used with the
> decompressor.
>

It is perfectly true that these options are used only during CPU 
validations and not in the end product. Still, it doesn't justify why 
these options are not to be used with decompressor. Or alternately, why 
would a user intend to disable a cache when it has been implemented 
correctly and is stable? Without this change, the effect of disabling 
cache is not reflected in entirety.

Regards
Amit Virdi
