Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3FAUaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 16:30:16 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:45643 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3FAUaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 16:30:13 -0400
Message-ID: <51AA59D0.7020805@gmail.com>
Date: Sat, 01 Jun 2013 15:30:08 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, patches@lists.linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 15/15] OF: remove #ifdef from linux/of_platform.h
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de> <1370038972-2318779-16-git-send-email-arnd@arndb.de> <CAL_Jsq+-7RizbVQSA-JnJRZFc9-3RFCXuCOXP=GfCin2Losfeg@mail.gmail.com> <201306012203.39133.arnd@arndb.de>
In-Reply-To: <201306012203.39133.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 03:03 PM, Arnd Bergmann wrote:
> On Saturday 01 June 2013, Rob Herring wrote:
>> On Fri, May 31, 2013 at 5:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> A lot of code uses the functions from of_platform.h when built for
>>> devicetree-enabled platforms but can also be built without them.
>>> In order to avoid using #ifdef everywhere in drivers, this
>>> makes all the function declarations visible, which means we
>>> can use "if (IS_ENABLED(CONFIG_OF))" in driver code and get build
>>> coverage over the code but let the compiler drop the reference
>>> in the object code.
>>>
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Grant Likely <grant.likely@linaro.org>
>>> Cc: Rob Herring <rob.herring@calxeda.com>
>>
>> I've got a more complete series for 3.11 that removes OF_DEVICE and
>> of_platform_driver completely. I'm waiting on ack from Ben H.
> 
> Ok. Does your series also remove the #ifdef CONFIG_OF part from this
> header?

No, we still need empty functions. Here is what of_device.h looks like:

http://tinyurl.com/l2azz5m

BTW, it has your ack.

Rob
