Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3FDNBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:01:16 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:61551 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab3FDNBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:01:14 -0400
MIME-Version: 1.0
In-Reply-To: <201306012257.02327.arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
	<201306012203.39133.arnd@arndb.de>
	<51AA59D0.7020805@gmail.com>
	<201306012257.02327.arnd@arndb.de>
Date: Tue, 4 Jun 2013 08:01:13 -0500
Message-ID: <CAL_JsqKMOy4CM=FXbsy7mQ1f0DLyK6n_cuZ92uhsSM2Mq-3B1g@mail.gmail.com>
Subject: Re: [PATCH 15/15] OF: remove #ifdef from linux/of_platform.h
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, patches@lists.linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 3:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 01 June 2013, Rob Herring wrote:
>> No, we still need empty functions. Here is what of_device.h looks like:
>>
>> http://tinyurl.com/l2azz5m
>>
>> BTW, it has your ack.
>>
>
> Could you add a patch on top that only puts the function declarations
> inside of #ifdef that don't have an inline wrapper?

I'm confused. You mean that DO have an inline? Like this:

void foo(void);

#ifdef CONFIG_OF
void bar(void);
#else
static inline void bar(void) {}
#endif

> It's really annoying to have to change the header file every time one
> needs to call a function from a driver in the DT-only case.

The functions without inlines are ones that drivers should not call
and should only be called from OF enabled code. That's why we have not
done a complete pass of adding inlines for everything.

Rob
