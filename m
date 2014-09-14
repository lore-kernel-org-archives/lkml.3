Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaINRaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:30:09 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55677 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbaINRaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:30:06 -0400
Message-ID: <5415D09A.4070204@kernel.org>
Date: Sun, 14 Sep 2014 18:30:02 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, Irina Tirdea <irina.tirdea@intel.com>,
        linux-iio@vger.kernel.org
CC: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iio: gyro: bmg160: only set power state if PM_RUNTIME
 is defined
References: <1410185127-13039-1-git-send-email-irina.tirdea@intel.com> <540F7BB5.2080801@gmx.de>
In-Reply-To: <540F7BB5.2080801@gmx.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 23:14, Hartmut Knaack wrote:
> Irina Tirdea schrieb, Am 08.09.2014 16:05:
>> When CONFIG_PM_RUNTIME is not defined and bmg160 tries to power
>> off the device, bmg160_set_power_state will call pm_runtime_put_autosuspend,
>> which is not implemented (wil return -ENOSYS).
>>
>> Only call bmg160_set_power_state when CONFIG_PM_RUNTIME is defined.
>>
>> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Acked-by: Hartmut Knaack <knaack.h@gmx.de>
Applied to the togreg branch of iio.git. Initially pushed out as testing
for the autobuilders to play.

Thanks,

Jonathan
>> ---
>>
>> Changes in v2:
>>  - moved ifdef CONFIG_PM_RUNTIME inside bmg160_set_power_state as
>> Hartmut Knaack suggested
>>
>>  drivers/iio/gyro/bmg160.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/iio/gyro/bmg160.c b/drivers/iio/gyro/bmg160.c
>> index 7524698..1f967e0d 100644
>> --- a/drivers/iio/gyro/bmg160.c
>> +++ b/drivers/iio/gyro/bmg160.c
>> @@ -237,6 +237,7 @@ static int bmg160_chip_init(struct bmg160_data *data)
>>  
>>  static int bmg160_set_power_state(struct bmg160_data *data, bool on)
>>  {
>> +#ifdef CONFIG_PM_RUNTIME
>>  	int ret;
>>  
>>  	if (on)
>> @@ -251,6 +252,7 @@ static int bmg160_set_power_state(struct bmg160_data *data, bool on)
>>  			"Failed: bmg160_set_power_state for %d\n", on);
>>  		return ret;
>>  	}
>> +#endif
>>  
>>  	return 0;
>>  }
>>
> 
