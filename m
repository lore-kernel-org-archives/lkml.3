Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab3K1KMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:12:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43594 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3K1KMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:12:35 -0500
Date: Thu, 28 Nov 2013 10:11:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Amit Virdi <amit.virdi@st.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "marc.ceeeee@gmail.com" <marc.ceeeee@gmail.com>,
        "spear--sw-devel@codex.cro.st.com" <spear--sw-devel@codex.cro.st.com>
Subject: Re: [PATCH] ARM: asm: Configure caches as per the defconfig
Message-ID: <20131128101154.GT16735@n2100.arm.linux.org.uk>
References: <1385553244-1513-1-git-send-email-amit.virdi@st.com> <20131127121425.GN16735@n2100.arm.linux.org.uk> <5296D7DF.202@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5296D7DF.202@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 11:12:55AM +0530, Amit Virdi wrote:
> On 11/27/2013 5:44 PM, Russell King - ARM Linux wrote:
>> On Wed, Nov 27, 2013 at 05:24:04PM +0530, Amit Virdi wrote:
>>> From: Amit VIRDI <Amit.VIRDI@st.com>
>>>
>>> In the current implementation of the decompression code, the caches are enabled
>>> irrespective of their configuration in the deconfig. This makes setting the
>>> ICACHE and DCACHE disable options from the menuconfig irrelevant. Change this
>>> implementation to enable caches only if specified in the defconfig.
>>
>> NAK.  These options are provided more for ARM Ltd's validation of CPUs
>> rather than for users, and it's not supposed to be used with the
>> decompressor.
>>
>
> It is perfectly true that these options are used only during CPU  
> validations and not in the end product. Still, it doesn't justify why  
> these options are not to be used with decompressor. Or alternately, why  
> would a user intend to disable a cache when it has been implemented  
> correctly and is stable? Without this change, the effect of disabling  
> cache is not reflected in entirety.

When doing CPU validations, the compressed image isn't used.
