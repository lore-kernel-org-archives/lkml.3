Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031AbaCXFax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 01:30:53 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62963 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaCXFav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 01:30:51 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <532FC307.7050202@roeck-us.net>
Date: Sun, 23 Mar 2014 22:30:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH] thermal: Fix KELVIN_TO_CELSIUS macro
References: <1395634496-25040-1-git-send-email-linux@roeck-us.net> <1395635132.13968.40.camel@joe-AO722>
In-Reply-To: <1395635132.13968.40.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2014 09:25 PM, Joe Perches wrote:
> On Sun, 2014-03-23 at 21:14 -0700, Guenter Roeck wrote:
>> It is always a good idea to use paranthesis around macro parameters
>> to avoid undesired side effects.
>>
>> In this specific case, KELVIN_TO_CELSIUS() is used in
>> drivers/platform/x86/asus-wmi.c with parameter "value & 0xFFFF",
>> which due to operator evaluation order causes more or less random
>> results.
>
> Maybe it's better to use a statement expression to avoid
> multiple calculations of t
>
> Maybe;
>
> #define KELVIN_TO_CELSIUS(t)				\
> ({							\
> 	long _t = (long)(t) - 2732;			\
> 	_t >= 0 ? (_t + 5) / 10 : (_t - 5) / 10;	\
> })
>
>

Possibly, but I only want to have a bug fixed which should possibly be applied
to -stable at some point. As such, I prefer the minimalistic approach.
Anything more fancy on top of that can be submitted as separate patch.

Guenter

