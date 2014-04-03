Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaDCVBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 17:01:40 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:32884 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbaDCVBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 17:01:37 -0400
Message-ID: <533DCC4E.4000303@linaro.org>
Date: Thu, 03 Apr 2014 16:02:06 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: bcm@fixthebug.org, mporter@linaro.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mach-bcm: clean up config and build targets
References: <1396557052-24029-1-git-send-email-elder@linaro.org> <1396558159.21212.4.camel@x220>
In-Reply-To: <1396558159.21212.4.camel@x220>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 03:49 PM, Paul Bolle wrote:
> On Thu, 2014-04-03 at 15:30 -0500, Alex Elder wrote:
>> Currently CONFIG_ARCH_BCM_MOBILE is used to select all Broadcom
>> mobile SoCs.  Instead, use that only as a config menu switch, and
>> define specific symbols like CONFIG_ARCH_BCM_281XX to select a
>> particular SoC family.  If ARCH_BCM_MOBILE is selected, all of the
>> SoCs will be selected by default, but this way each can be disabled
>> individually as well.
>>
>> This allows more precision in controlling what gets built under
>> mach-bcm.  Another benefit to doing this is that it makes it obvious
>> that the code that implements SMC calls to control L2 cache is only
>> used for BCM281XX (for example).
>>
>> Also use Kbuild's $(<modulename>-y) variable mechanism to build a
>> single object file containing everything used for the bcm281xx board
>> in arch/arm/mach-bcm.
>>
>> Note:  This patch is based on the current arm-soc/for-next branch:
>>     e98cd72 arm-soc: document samsung merges
>>
>> The patch is available here:
>>     http://git.linaro.org/landing-teams/working/broadcom/kernel.git
>>     Branch review/mach-bcm-cleanup
> 
> It seems the last two paragraphs should actually be below the "---"
> marker. There's no need to include them in the commit explanation, is
> there?

You're right.  Sorry about that.

I got another comment too and will be doing a v2 shortly.

					-Alex
> 
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
> 
> 
> Paul Bolle
> 

