Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011Ab3GSGPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 02:15:43 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:43886 "EHLO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3GSGPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 02:15:41 -0400
MIME-Version: 1.0
In-Reply-To: <51E816BD.9010302@metafoo.de>
References: <1374162430-30709-1-git-send-email-x0199363@ti.com>
	<51E816BD.9010302@metafoo.de>
Date: Fri, 19 Jul 2013 09:15:39 +0300
Message-ID: <CAGH3droXKeE7diARCZQ=n37XkAmYzrcUkyZLvcWjWVLHvJnWVw@mail.gmail.com>
Subject: Re: [PATCH] iio: core: Avoid double minus in sysfs output
From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Oleksandr Kravchenko <x0199363@ti.com>, jic23@cam.ac.uk,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 7:24 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 07/18/2013 05:47 PM, Oleksandr Kravchenko wrote:
>> From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
>>
>> This patch fixes the issue with double minus in output when
>> reading channels from sysfs for IIO_VAL_INT_PLUS_MICRO and
>> IIO_VAL_INT_PLUS_NANO cases. Until this patch if val and val2
>> both are negatives output string contains "--" before
>> digits. It is result of "-%d..." in sprintf() format.
>>
>
> Hm, this might be a bug in a driver that is triggering this. The idea is
> that val2 is only allowed to be negative if val is 0.
>
> - Lars
>
If I calculate val and val2 in next way:
*val = adc / 1000000;
*val2 = adc % 1000000;
both val and val2 could by negative. Do I have to check it in my driver?
