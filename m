Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaLIHwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:52:03 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45023 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaLIHv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:51:59 -0500
Message-ID: <5486AA1A.4060802@tandemg.com>
Date: Tue, 09 Dec 2014 09:51:54 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: dmitry.torokhov@gmail.com, LW@KARO-electronics.de, B38611@freescale.com,
        maksqwe1@ukr.net, jg1.han@samsung.com, linux@rasmusvillemoes.dk,
        fabf@skynet.be, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: edt-ft5x06: fixed a macro coding style issue
References: <20141209063456.GA15121@ubuntu> <1418107460.15957.9.camel@perches.com>
In-Reply-To: <1418107460.15957.9.camel@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 08:44 AM, Joe Perches wrote:
> On Tue, 2014-12-09 at 08:34 +0200, Asaf Vertz wrote:
>> Fixed a coding style error, macros with complex values should be
>> enclosed in parentheses.
>>  
>> -#define EDT_ATTR_CHECKSET(name, reg) \
>> +#define EDT_ATTR_CHECKSET(name, reg) { \
>>  	if (pdata->name >= edt_ft5x06_attr_##name.limit_low &&		\
>>  	    pdata->name <= edt_ft5x06_attr_##name.limit_high)		\
>> -		edt_ft5x06_register_write(tsdata, reg, pdata->name)
>> +		edt_ft5x06_register_write(tsdata, reg, pdata->name);	\
>> +}
> 
> Any time you see a naked if (foo) bar in a macro
> prefer to use a do while (0) like;
> 
> #define EDT_ATTR_CHECKSET(name, reg)					\
> do {									\
> 	if (pdata->name >= edt_ft5x06_attr_##name.limit_low &&		\
> 	    pdata->name <= edt_ft5x06_attr_##name.limit_high)		\
> 		edt_ft5x06_register_write(tsdata, reg, pdata->name);	\
> while (0)
> 

thanks for the input, I will update and resend it

