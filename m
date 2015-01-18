Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbbARLq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:46:59 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:57864 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbbARLq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:46:57 -0500
X-IronPort-AV: E=Sophos;i="5.09,420,1418112000"; 
   d="scan'208";a="54915944"
Message-ID: <54BB9D2B.20408@broadcom.com>
Date: Sun, 18 Jan 2015 12:46:51 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Ray Jui <rjui@broadcom.com>,
        "Mark Rutland" <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        "Christian Daudt" <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Scott Branden" <sbranden@broadcom.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <mporter@linaro.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <linux-i2c@vger.kernel.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
References: <rjui@broadcom.com> <1421451737-7107-1-git-send-email-rjui@broadcom.com> <1421451737-7107-3-git-send-email-rjui@broadcom.com> <54BB795C.6040402@broadcom.com> <20150118094741.GE22880@pengutronix.de> <20150118110658.GA1113@katana> <20150118111759.GG22880@pengutronix.de>
In-Reply-To: <20150118111759.GG22880@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/15 12:17, Uwe Kleine-König wrote:
> Hello Wolfram,
>
> On Sun, Jan 18, 2015 at 12:06:58PM +0100, Wolfram Sang wrote:
>> On Sun, Jan 18, 2015 at 10:47:41AM +0100, Uwe Kleine-König wrote:
>>> On Sun, Jan 18, 2015 at 10:14:04AM +0100, Arend van Spriel wrote:
>>>> On 01/17/15 00:42, Ray Jui wrote:
>>>>> +	complete_all(&iproc_i2c->done);
>>>>
>>>> Looking over this code it seems to me there is always a single
>>>> process waiting for iproc_i2c->done to complete. So using complete()
>>>> here would suffice.
>>> Yeah, there is always only a single thread waiting. That means both
>>> complete and complete_all are suitable. AFAIK there is no reason to pick
>>> one over the other in this case.
>>
>> Clarity?
> And which do you consider more clear? complete_all might result in the
> question: "Is there>1 waiter?" and complete might yield to "What about
> the other waiters?". If you already know there is only one, both are on
> par on clarity. Might only be me?! I don't care much.

Maybe it is me, but it is not about questions but it is about implicit 
statements that the code makes (or reader derives from it). When using 
complete_all you indicate to the reader "there can be more than one 
waiter". When using complete it indicates "there is only one waiter". If 
those statements are not true that is a code issue/bug.

Regards,
Arend

> Best regards
> Uwe
>

