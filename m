Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaGTMiF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 08:38:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:37842 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbaGTMiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 08:38:03 -0400
Message-ID: <53CBB8B7.6000309@kernel.org>
Date: Sun, 20 Jul 2014 13:40:23 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Reyad Attiyat <reyad.attiyat@gmail.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 4/4] iio: hid-sensor-magn-3d: Add support for rotation
 from north
References: <1405621109-21147-1-git-send-email-reyad.attiyat@gmail.com> <1405621109-21147-5-git-send-email-reyad.attiyat@gmail.com> <53CAFEFD.3040500@linux.intel.com>
In-Reply-To: <53CAFEFD.3040500@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/07/14 00:27, Srinivas Pandruvada wrote:
>
> On 07/17/2014 11:18 AM, Reyad Attiyat wrote:
>> Add the HID usage attribute ID's and IIO channel info for rotation
>> from north support.
>>
>> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
> Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Applied to the togreg branch of iio.git.  This will be initially pushed out
as testing for the autobuilders to play with.

Thanks,
>> ---
>>   drivers/iio/magnetometer/hid-sensor-magn-3d.c | 53 ++++++++++++++++++++++++++-
>>   1 file changed, 52 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> index d3b9114..3ec777a 100644
>> --- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> +++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> @@ -35,6 +35,10 @@ enum magn_3d_channel {
>>       CHANNEL_SCAN_INDEX_X,
>>       CHANNEL_SCAN_INDEX_Y,
>>       CHANNEL_SCAN_INDEX_Z,
>> +    CHANNEL_SCAN_INDEX_NORTH_MAGN_TILT_COMP,
>> +    CHANNEL_SCAN_INDEX_NORTH_TRUE_TILT_COMP,
>> +    CHANNEL_SCAN_INDEX_NORTH_MAGN,
>> +    CHANNEL_SCAN_INDEX_NORTH_TRUE,
>>       MAGN_3D_CHANNEL_MAX,
>>   };
>> @@ -57,7 +61,11 @@ struct magn_3d_state {
>>   static const u32 magn_3d_addresses[MAGN_3D_CHANNEL_MAX] = {
>>       HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS,
>>       HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS,
>> -    HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS
>> +    HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS,
>> +    HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH,
>> +    HID_USAGE_SENSOR_ORIENT_COMP_TRUE_NORTH,
>> +    HID_USAGE_SENSOR_ORIENT_MAGN_NORTH,
>> +    HID_USAGE_SENSOR_ORIENT_TRUE_NORTH,
>>   };
>>   /* Channel definitions */
>> @@ -89,6 +97,42 @@ static const struct iio_chan_spec magn_3d_channels[] = {
>>           BIT(IIO_CHAN_INFO_SCALE) |
>>           BIT(IIO_CHAN_INFO_SAMP_FREQ) |
>>           BIT(IIO_CHAN_INFO_HYSTERESIS),
>> +    }, {
>> +        .type = IIO_ROT,
>> +        .modified = 1,
>> +        .channel2 = IIO_MOD_NORTH_MAGN_TILT_COMP,
>> +        .info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
>> +        .info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
>> +        BIT(IIO_CHAN_INFO_SCALE) |
>> +        BIT(IIO_CHAN_INFO_SAMP_FREQ) |
>> +        BIT(IIO_CHAN_INFO_HYSTERESIS),
>> +    }, {
>> +        .type = IIO_ROT,
>> +        .modified = 1,
>> +        .channel2 = IIO_MOD_NORTH_TRUE_TILT_COMP,
>> +        .info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
>> +        .info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
>> +        BIT(IIO_CHAN_INFO_SCALE) |
>> +        BIT(IIO_CHAN_INFO_SAMP_FREQ) |
>> +        BIT(IIO_CHAN_INFO_HYSTERESIS),
>> +    }, {
>> +        .type = IIO_ROT,
>> +        .modified = 1,
>> +        .channel2 = IIO_MOD_NORTH_MAGN,
>> +        .info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
>> +        .info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
>> +        BIT(IIO_CHAN_INFO_SCALE) |
>> +        BIT(IIO_CHAN_INFO_SAMP_FREQ) |
>> +        BIT(IIO_CHAN_INFO_HYSTERESIS),
>> +    }, {
>> +        .type = IIO_ROT,
>> +        .modified = 1,
>> +        .channel2 = IIO_MOD_NORTH_TRUE,
>> +        .info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
>> +        .info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
>> +        BIT(IIO_CHAN_INFO_SCALE) |
>> +        BIT(IIO_CHAN_INFO_SAMP_FREQ) |
>> +        BIT(IIO_CHAN_INFO_HYSTERESIS),
>>       }
>>   };
>> @@ -245,6 +289,13 @@ static int magn_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
>>           offset = (usage_id - HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS)
>>                   + CHANNEL_SCAN_INDEX_X;
>>       break;
>> +    case HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH:
>> +    case HID_USAGE_SENSOR_ORIENT_COMP_TRUE_NORTH:
>> +    case HID_USAGE_SENSOR_ORIENT_MAGN_NORTH:
>> +    case HID_USAGE_SENSOR_ORIENT_TRUE_NORTH:
>> +        offset = (usage_id - HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH)
>> +                + CHANNEL_SCAN_INDEX_NORTH_MAGN_TILT_COMP;
>> +    break;
>>       default:
>>           return -EINVAL;
>>       }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

