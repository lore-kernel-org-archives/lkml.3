Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaLDJnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:43:04 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22328 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaLDJm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:42:59 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-36-54802ca05e46
Message-id: <54802C9F.8030101@samsung.com>
Date: Thu, 04 Dec 2014 10:42:55 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Subject: Re: [PATCH/RFC v9 02/19] Documentation: leds: Add description of LED
 Flash class extension
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-3-git-send-email-j.anaszewski@samsung.com>
 <20141203170818.GN14746@valkosipuli.retiisi.org.uk>
In-reply-to: <20141203170818.GN14746@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4Fd0FOg0hBhe/a1tsnLGe1eLozolM
	Fv1vFrJanHu1ktHibNMbdovLu+awWWx9s47RomfDVlaLpdcvMlncPXWUzWLC9LUsFq17j7Bb
	7N71lNXi8Jt2Vosz+1eyOfB7rJm3htHjcl8vk8fOWXfZPVYu/8LmcfjrQhaPTas62Tz2zP/B
	6tG3ZRWjx4rV39k9Pm+SC+CK4rJJSc3JLEst0rdL4Mr43DmNveChZMXmAw9ZGxgfiHQxcnJI
	CJhIrFvZwAZhi0lcuLceyObiEBJYyihxfdZ7FgjnI6PE0fPnWUGqeAW0JD4e/8IEYrMIqErM
	+/aRHcRmEzCU+PniNVhcVCBC4s/pfVD1ghI/Jt9jAbFFBNQknm56CDaUWeAak8SG9SfBGoQF
	UiWObr7HDGILCexllFi6UgvE5hRwkLj76jxYM7OAtcTKSdsYIWx5ic1r3jJPYBSYhWTHLCRl
	s5CULWBkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREmtfdzAuPWZ1iFGAg1GJh3fC9foQ
	IdbEsuLK3EOMEhzMSiK8jH+BQrwpiZVVqUX58UWlOanFhxiZODilGhhDTPemayc+f3D7ZAL/
	irkxl68rhZdXHbF008hkW7139/8W3d7p/LGfpl0Sv5q8dq6X5fSYZTMehF3ieRV9YOH1Z+Fa
	etFv01ZLiN2a6ZhXVHn46UOdZ4ZXU9wj1bK6DCe3T2HWPrLPOo/PT+jY1DnfDu8TsWjt2qv0
	w94rp2hzkqKaZMPn/2pKLMUZiYZazEXFiQCvddsrkwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

Thanks for the review.

On 12/03/2014 06:08 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Wed, Dec 03, 2014 at 05:06:37PM +0100, Jacek Anaszewski wrote:
>> The documentation being added contains overall description of the
>> LED Flash Class and the related sysfs attributes.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>   Documentation/leds/leds-class-flash.txt |   50 +++++++++++++++++++++++++++++++
>>   1 file changed, 50 insertions(+)
>>   create mode 100644 Documentation/leds/leds-class-flash.txt
>>
>> diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
>> new file mode 100644
>> index 0000000..82e58b1
>> --- /dev/null
>> +++ b/Documentation/leds/leds-class-flash.txt
>> @@ -0,0 +1,50 @@
>> +
>> +Flash LED handling under Linux
>> +==============================
>> +
>> +Some LED devices support two modes - torch and flash. The modes are
>> +supported by the LED class (see Documentation/leds/leds-class.txt)
>> +and LED Flash class respectively.
>> +
>> +In order to enable support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol
>> +must be defined in the kernel config. A flash LED driver must register
>> +in the LED subsystem with led_classdev_flash_register to gain flash
>> +capabilities.
>> +
>> +Following sysfs attributes are exposed for controlling flash led devices:
>> +
>> +	- flash_brightness - flash LED brightness in microamperes (RW)
>> +	- max_flash_brightness - maximum available flash LED brightness (RO)
>> +	- flash_timeout - flash strobe duration in microseconds (RW)
>> +	- max_flash_timeout - maximum available flash strobe duration (RO)
>> +	- flash_strobe - flash strobe state (RW)
>> +	- flash_sync_strobe - one flash device can control more than one
>> +			      sub-led; when this atrribute is set to 1
>
> s/atrribute/attribute/
>
>> +			      the flash led will be strobed synchronously
>> +			      with the other one controlled by the same
>> +			      device; flash timeout setting is inherited
>> +			      from the led being strobed explicitly and
>> +			      flash brightness setting of a sub-led's
>> +			      being synchronized is used (RW)
>
> The flash brightness shouldn't be determined by the strobed LED. If this is
> a property of the hardware, then be it, but in general no, it it shouldn't
> be an interface requirement. I think this should just say that the strobe is
> synchronised.

I intended this to sound exactly as you laid it out above, but maybe it
is obscure English. "and flash brightness setting of a sub-led >>>being
synchronized<<< is used" - from my point of view the led being
synchronized is the one that isn't strobed explicitly. But I'm ok with
confining ourselves only to saying that strobe is synchronized.

> How does the user btw. figure out which flash LEDs may be strobed
> synchronously using the LED flash interface?

The flash_sync_strobe argument is absent if synchronized strobe
is not available for a LED. The driver defines this by setting
newly added LED_DEV_CAP_COMPOUND flag.

Best Regards,
Jacek Anaszewski
