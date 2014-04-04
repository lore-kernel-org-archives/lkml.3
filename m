Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbaDDPSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:18:21 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49308 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbaDDPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:18:16 -0400
Message-ID: <533ECD34.5030502@linaro.org>
Date: Fri, 04 Apr 2014 16:18:12 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: patches@linaro.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH] arm: Fix DEBUG_LL for multi-platform kernels (without
 PL01X)
References: <1396610269-11580-1-git-send-email-daniel.thompson@linaro.org> <20140404144108.GD7528@n2100.arm.linux.org.uk>
In-Reply-To: <20140404144108.GD7528@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 15:41, Russell King - ARM Linux wrote:
>> The happens because the multi-platform mode may include ARCH_SPEAR13XX
>> and this forcibly engages DEBUG_UART_PL01X to provide some kind of
>> compatibility with single platform builds (SPEAr supports both single and
>> multi-platform). This in turn causes DEBUG_LL_INCLUDE to wedge at
>> debug/pl01x.S.
>>
>> Problem is fixed by only deploying the compatibility options for SPEAr
>> when ARCH_MULTIPLATFORM is not set.
> 
> I think it's probably about time we killed the def_bool and just made
> this a plain 'bool'.  The affected platforms should be using
> DEBUG_LL_UART_PL01X by now.

Ok.

Looking closely I think this will actually be better even for the single
platforms since today KConfig will not honour targeting DEBUG_LL at
EmbeddedICE or semihosting on the platforms that remain in the list.

Expect a v3...



Daniel.
