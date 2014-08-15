Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaHOPj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:39:29 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53079 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaHOPj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:39:28 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53EE29AC.6050709@roeck-us.net>
Date: Fri, 15 Aug 2014 08:39:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Phil Pokorny <ppokorny@penguincomputing.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
CC: "clemens@ladisch.de" <clemens@ladisch.de>,
        "jdelvare@suse.de" <jdelvare@suse.de>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "bp@suse.de" <bp@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH V3] hwmon, k10temp: Add support for F15h
 M60h
References: <1408058127-19374-1-git-send-email-aravind.gopalakrishnan@amd.com>	<53EDE4B3.6090903@roeck-us.net>	<53EE1E04.9080406@amd.com> <CAAek22FpQRhDqjSQjOL_UfoJ51hHqbxYZu2AGTA54LRM9sFn2g@mail.gmail.com>
In-Reply-To: <CAAek22FpQRhDqjSQjOL_UfoJ51hHqbxYZu2AGTA54LRM9sFn2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 08:18 AM, Phil Pokorny wrote:
>
>         On 08/14/2014 04:15 PM, Aravind Gopalakrishnan wrote:
>
>             This patch adds temperature monitoring support for F15h M60h processor.
>                - Add new pci device id for the relevant processor
>                - The functionality of REG_REPORTED_TEMPERATURE is moved to
>                  D0F0xBC_xD820_0CA4 [Reported Temperature Control]
>                  - So, use this to get CUR_TEMP value
>                  - Since we need an indirect register access, protect this with
>                    a mutex lock
>
>
> What about making this a new driver forked from k10temp.
>
> AMD has changed how they report temperatures and the very different method of getting these temps suggests that it is no longer reasonable to add support to this driver for these new chips. Particular attention to the mutex required to protect the indirect register suggests that this would benefit from focus in its own driver now that there are multiple members of the "k15temp" family.
>
> Anyone else have thoughts?
>

Everything in that new driver except for reading the actual temperature
would be exactly the same. That doesn't make sense to me.

Guenter

