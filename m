Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbbAZNfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:35:12 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:36577 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbbAZNfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:35:09 -0500
Message-ID: <54C6426E.9090808@atmel.com>
Date: Mon, 26 Jan 2015 14:34:38 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Sylvain Rochet <sylvain.rochet@finsecur.com>,
        Wenyou Yang <wenyou.yang@atmel.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <alexandre.belloni@free-electrons.com>,
        <peda@axentia.se>
Subject: Re: [PATCH v2 02/12] pm: at91: Workaround DDRSDRC self-refresh bug
 with LPDDR1 memories.
References: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com> <1422265139-23011-1-git-send-email-wenyou.yang@atmel.com> <20150126103605.GA20837@gradator.net>
In-Reply-To: <20150126103605.GA20837@gradator.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 26/01/2015 11:36, Sylvain Rochet a écrit :
> Hello Wenyou,
> 
> On Mon, Jan 26, 2015 at 05:38:59PM +0800, Wenyou Yang wrote:
>> From: Peter Rosin <peda@axentia.se>
>>
>> The DDRSDR controller fails miserably to put LPDDR1 memories in
>> self-refresh. Force the controller to think it has DDR2 memories
>> during the self-refresh period, as the DDR2 self-refresh spec is
>> equivalent to LPDDR1, and is correctly implemented in the
>> controller.
>>
>> Assume that the second controller has the same fault, but that is
>> untested.
>>
>> Signed-off-by: Peter Rosin <peda@axentia.se>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  arch/arm/mach-at91/pm_slowclock.S  |   43 +++++++++++++++++++++++++++++++-----
>>  include/soc/at91/at91sam9_ddrsdr.h |    2 +-
>>  2 files changed, 39 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
>> index e2bfaf5..1155217 100644
>> --- a/arch/arm/mach-at91/pm_slowclock.S
>> +++ b/arch/arm/mach-at91/pm_slowclock.S
>> @@ -100,6 +100,16 @@ ddr_sr_enable:
>>  	cmp	memctrl, #AT91_MEMCTRL_DDRSDR
>>  	bne	sdr_sr_enable
>>  
>> +	/* LPDDR1 --> force DDR2 mode during self-refresh */
> 
> I think we should explain we are dealing with an errata here, this is 
> not obvious at first sight, the patch summary may find its place here :-)

True but the problem is that this errata is not public yet, it will be
in a couple of weeks.

I have the feeling though that the commit message is pretty clear. We'll
maybe add that it"s an actual errata.

Bye,
-- 
Nicolas Ferre
