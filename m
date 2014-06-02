Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbaFBQaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:30:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48625 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbaFBQaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:30:03 -0400
Message-ID: <538CA683.40108@ti.com>
Date: Mon, 2 Jun 2014 12:29:55 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Garrett Ding <g-ding@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] i2c: davinci: Add block read functionality for IPMI
References: <1398970186-12204-1-git-send-email-m-karicheri2@ti.com> <537DD6B1.9010200@ti.com>
In-Reply-To: <537DD6B1.9010200@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/2014 6:51 AM, Sekhar Nori wrote:
> On Friday 02 May 2014 12:19 AM, Murali Karicheri wrote:
>> Intelligent Plaform Management Interface (IPMI) requires I2C driver
>> to support block read, where the first byte received from slave is
>> the length of following data:-
>>   Added length check if the read type is block read (I2C_M_RECV_LEN)
>>   Send NACK/STOP bits before last byte is received
>>
>> Signed-off-by: Garrett Ding <g-ding@ti.com>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> I tested this on a DA850 using i2cdetect and it did not seem to break
> anything so:
>
> Tested-by: Sekhar Nori <nsekhar@ti.com>
>
> There are some checks that were triggered in checkpatch. You may want
> to fix them up.
>
> Thanks,
> Sekhar
>
> CHECK: Alignment should match open parenthesis
> #112: FILE: drivers/i2c/busses/i2c-davinci.c:557:
> +					w = davinci_i2c_read_reg(dev,
> +							DAVINCI_I2C_MDR_REG);
>
> CHECK: Alignment should match open parenthesis
> #115: FILE: drivers/i2c/busses/i2c-davinci.c:560:
> +					davinci_i2c_write_reg(dev,
> +							DAVINCI_I2C_MDR_REG, w);
>
> CHECK: Alignment should match open parenthesis
> #119: FILE: drivers/i2c/busses/i2c-davinci.c:564:
> +					davinci_i2c_write_reg(dev,
> +							DAVINCI_I2C_MDR_REG, w);
>
> total: 0 errors, 0 warnings, 3 checks, 67 lines checked
>
Sekhar,

Thanks for testing this. I have other comments against this patch and 
will be sending an
updated patch in few weeks.

Thanks and regards,

Murali
