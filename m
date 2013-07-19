Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3GSVG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:06:59 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39592 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3GSVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:06:57 -0400
Message-ID: <51E9AA6D.3070007@kernel.org>
Date: Fri, 19 Jul 2013 22:06:53 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Oleksandr Kravchenko <x0199363@ti.com>, jic23@cam.ac.uk,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: core: Avoid double minus in sysfs output
References: <1374162430-30709-1-git-send-email-x0199363@ti.com> <51E816BD.9010302@metafoo.de> <CAGH3droXKeE7diARCZQ=n37XkAmYzrcUkyZLvcWjWVLHvJnWVw@mail.gmail.com>
In-Reply-To: <CAGH3droXKeE7diARCZQ=n37XkAmYzrcUkyZLvcWjWVLHvJnWVw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 07:15 AM, Oleksandr Kravchenko wrote:
> On Thu, Jul 18, 2013 at 7:24 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> On 07/18/2013 05:47 PM, Oleksandr Kravchenko wrote:
>>> From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
>>>
>>> This patch fixes the issue with double minus in output when
>>> reading channels from sysfs for IIO_VAL_INT_PLUS_MICRO and
>>> IIO_VAL_INT_PLUS_NANO cases. Until this patch if val and val2
>>> both are negatives output string contains "--" before
>>> digits. It is result of "-%d..." in sprintf() format.
>>>
>>
>> Hm, this might be a bug in a driver that is triggering this. The idea is
>> that val2 is only allowed to be negative if val is 0.
>>
>> - Lars
>>
> If I calculate val and val2 in next way:
> *val = adc / 1000000;
> *val2 = adc % 1000000;
> both val and val2 could by negative. Do I have to check it in my driver?
> 
I guess it is will happen occasionally.  In the c89 standard, module for a negative
is implementation specific.  Anyone know if we can assume this will work in all cases
within the kernel?
