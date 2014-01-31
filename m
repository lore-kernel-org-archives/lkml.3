Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbaAaNAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 08:00:11 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:47788 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360AbaAaNAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 08:00:09 -0500
Message-ID: <52EB9E54.2020008@epfl.ch>
Date: Fri, 31 Jan 2014 14:00:04 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>
Subject: Re: [PATCH v2 4/6] can: sja1000: fuse of_platform into platform
References: <1391164513-11529-1-git-send-email-florian.vaussard@epfl.ch> <1391164513-11529-5-git-send-email-florian.vaussard@epfl.ch> <52EB9824.2010703@pengutronix.de> <52EB9AEA.4010503@epfl.ch> <52EB9BE1.6060407@pengutronix.de> <52EB9C48.3010205@pengutronix.de>
In-Reply-To: <52EB9C48.3010205@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/31/2014 01:51 PM, Marc Kleine-Budde wrote:
> On 01/31/2014 01:49 PM, Marc Kleine-Budde wrote:
>> On 01/31/2014 01:45 PM, Florian Vaussard wrote:
>>> Hello Marc,
>>>
>>> On 01/31/2014 01:33 PM, Marc Kleine-Budde wrote:
>>>> On 01/31/2014 11:35 AM, Florian Vaussard wrote:
>>>>> The OpenFirmware probe can be merged into the standard platform
>>>>> probe to leverage common code.
>>>>
>>>> Good work, as we want to replace the existing driver, I'm quite picky on
>>>> this patch, see more comments inline.
>>>>
>>>> Please don't delete of of_platform driver, yet.
>>>>
>>>
>>> Do you have any reason for not deleting of_platform? After this patch,
>>> we will have duplicated functionalities, this may be misleading for
>>> other people.
>>
>> Okay.
>> IIRC there _was_ a problem on sparc, it _should_ be fixed now, better
>> get a Tested-by from Andreas (Cc'ed).
> 

So it is ok for you if I remove of_platform, right?

> You have to use irq_of_parse_and_map() on sparc, but your patches does this.
> 

My first implementation was not using irq_of_parse_and_map(), as I do
not need it on ARM, but I suspected that other people might need it.
This is why the final code is slightly more complicated to handle both
cases.

Regards,
Florian
