Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaKVMHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 07:07:13 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:40392 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaKVMHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 07:07:11 -0500
Message-ID: <54707C6E.4060807@kernel.org>
Date: Sat, 22 Nov 2014 12:07:10 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, Fabian Frederick <fabf@skynet.be>,
        linux-kernel@vger.kernel.org
CC: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] iio: common: remove unnecessary sizeof(u8)
References: <1416141204-19989-1-git-send-email-fabf@skynet.be> <546FE632.6020803@gmx.de>
In-Reply-To: <546FE632.6020803@gmx.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/14 01:26, Hartmut Knaack wrote:
> Fabian Frederick schrieb am 16.11.2014 13:33:
>> sizeof(u8) is always 1.
>>
>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> Acked-by: Hartmut Knaack <knaack.h@gmx.de>
Applied to the togreg branch of iio.git - initially pushed out as testing for
the autobuilders to play with it.

Thanks,

Jonathan
>> ---
>>  drivers/iio/common/st_sensors/st_sensors_spi.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iio/common/st_sensors/st_sensors_spi.c b/drivers/iio/common/st_sensors/st_sensors_spi.c
>> index 78a6a1a..5b37737 100644
>> --- a/drivers/iio/common/st_sensors/st_sensors_spi.c
>> +++ b/drivers/iio/common/st_sensors/st_sensors_spi.c
>> @@ -54,7 +54,7 @@ static int st_sensors_spi_read(struct st_sensor_transfer_buffer *tb,
>>  	if (err)
>>  		goto acc_spi_read_error;
>>  
>> -	memcpy(data, tb->rx_buf, len*sizeof(u8));
>> +	memcpy(data, tb->rx_buf, len);
>>  	mutex_unlock(&tb->buf_lock);
>>  	return len;
>>  
>>
> 

