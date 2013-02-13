Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309Ab3BMQdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:33:12 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:51610 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759377Ab3BMQdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:33:10 -0500
Message-ID: <511BC043.4030506@gmail.com>
Date: Wed, 13 Feb 2013 10:33:07 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
CC: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 1/4] clocksource: pass DT node pointer to init functions
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com> <1360264144-20714-2-git-send-email-robherring2@gmail.com> <CAHTX3dKLCbfhBaHKBE=fVTcRReVL6yotA9e_8S70bH+_gajL5Q@mail.gmail.com>
In-Reply-To: <CAHTX3dKLCbfhBaHKBE=fVTcRReVL6yotA9e_8S70bH+_gajL5Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 10:21 AM, Michal Simek wrote:
> 2013/2/7 Rob Herring <robherring2@gmail.com>:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> In cases where we have multiple nodes of the same type, we may need the
>> node pointer to know which node was matched. Passing the node pointer
>> also keeps the init function from having to match the node a 2nd time.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: John Stultz <johnstul@us.ibm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  drivers/clocksource/clksrc-of.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Tested-by: Michal Simek <michal.simek@xilinx.com>
> 
> The rest is just the same as I have done. Any option to add these
> patches to v3.9?

I would like to before we have more users to fix, but it will have to be
post rc1. If not, Arnd/Olof should be be able to provide a stable branch
for 3.10.

> Because I need these patches for zynq timer because we have two in the soc.
> Is it OK to register several clock source and clockevent devices?

If it is 1 DT node, then that should be fine.

> btw: there is still one issue because you can just setup only one
> compatibility string.

You can have multiple CLOCKSOURCE_OF_DECLARE statements. The gic code
does this for irqchips.

Rob

