Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaHKNpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:45:35 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34179 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbaHKNpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:45:32 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-f4-53e8c8f84881
Message-id: <53E8C8F7.2070101@samsung.com>
Date: Mon, 11 Aug 2014 15:45:27 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC v4 15/21] media: Add registration helpers for V4L2 flash
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
 <1405087464-13762-16-git-send-email-j.anaszewski@samsung.com>
 <53CCF59E.3070200@iki.fi> <53DF9C2A.8060403@samsung.com>
 <20140811122628.GG16460@valkosipuli.retiisi.org.uk>
 <53E8C4BA.6050805@samsung.com>
In-reply-to: <53E8C4BA.6050805@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xa7o/T7wINnhvZ7FxxnpWi/lHzrFa
	LPm5i8nibNMbdovLu+awWWx9s47RomfDVlaLM/tXsjlweEz5vZHV4/DXhSwefVtWMXp83iQX
	wBLFZZOSmpNZllqkb5fAlXH02AXGglaJivMn3rI3MM4Q7GLk5JAQMJFo3NDFDGGLSVy4t56t
	i5GLQ0hgKaPEo7tPmSCcj4wSb76cZ+li5ODgFdCS2LXKF6SBRUBV4sHtnawgNpuAocTPF6+Z
	QGxRgQiJP6f3gcV5BQQlfky+xwJiiwioSTzd9JAFZCazwHVGiRXvHrKDJIQFAiQWXJ4J1iAk
	MItJ4tKXKhCbU0BbYuOnV2DXMQtYS6yctI0RwpaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyi
	qaXJBcVJ6bmGesWJucWleel6yfm5mxghQf5lB+PiY1aHGAU4GJV4eA1O3w0WYk0sK67MPcQo
	wcGsJMJ7a9WLYCHelMTKqtSi/Pii0pzU4kOMTBycUg2MCm+8pzO07LvvoH1gxpwSm8yH39+9
	frju8svDAisbz/1/bLt2it6OgkMcho2qT+zvOZY51VqIGUstfGjvu//Lh/ZbGvGvjiQItL3s
	+MB+Kn7K0kaWc/+Zdj3ac9f2dmyris/Et9mv9xraVXbrnNVP7PtY+unhD4crf6YvPh7z1njL
	Uf/M/bGb9iuxFGckGmoxFxUnAgAjsSfvUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 08/11/2014 02:26 PM, Sakari Ailus wrote:
>>
>> Hi Jacek,
>>

...

>>>>> +static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
>>>>> +{
>>>>> +    struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
>>>>> +    struct led_classdev_flash *flash = v4l2_flash->flash;
>>>>> +    struct v4l2_flash_ctrl *ctrl = &v4l2_flash->ctrl;
>>>>> +    struct v4l2_flash_ctrl_config *config = &v4l2_flash->config;
>>>>> +    enum led_brightness torch_brightness;
>>>>> +    bool external_strobe;
>>>>> +    int ret;
>>>>> +
>>>>> +    switch (c->id) {
>>>>> +    case V4L2_CID_FLASH_LED_MODE:
>>>>> +        switch (c->val) {
>>>>> +        case V4L2_FLASH_LED_MODE_NONE:
>>>>> +            call_flash_op(v4l2_flash, torch_brightness_set,
>>>>> +                            &flash->led_cdev, 0);
>>>>> +            return call_flash_op(v4l2_flash, strobe_set, flash,
>>>>> +                            false);
>>>>> +        case V4L2_FLASH_LED_MODE_FLASH:
>>>>> +            /* Turn off torch LED */
>>>>> +            call_flash_op(v4l2_flash, torch_brightness_set,
>>>>> +                            &flash->led_cdev, 0);
>>>>> +            external_strobe = (ctrl->source->val ==
>>>>> +                    V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
>>>>> +            return call_flash_op(v4l2_flash, external_strobe_set,
>>>>> +                        flash, external_strobe);
>>>>> +        case V4L2_FLASH_LED_MODE_TORCH:
>>>>> +            /* Stop flash strobing */
>>>>> +            ret = call_flash_op(v4l2_flash, strobe_set, flash,
>>>>> +                            false);
>>>>> +            if (ret)
>>>>> +                return ret;
>>>>> +
>>>>> +            torch_brightness =
>>>>> +                v4l2_flash_intensity_to_led_brightness(
>>>>> +                        &config->torch_intensity,
>>>>> +                        ctrl->torch_intensity->val);
>>>>> +            call_flash_op(v4l2_flash, torch_brightness_set,
>>>>> +                    &flash->led_cdev, torch_brightness);
>>>>> +            return ret;
>>>>> +        }
>>>>> +        break;
>>>>> +    case V4L2_CID_FLASH_STROBE_SOURCE:
>>>>> +        external_strobe = (c->val ==
>>>>> V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
>>>>
>>>> Is the external_strobe argument match exactly to the strobe source
>>>> control? You seem to assume that in g_volatile_ctrl() above. I think
>>>> having it the either way is fine but not both. :-)
>>>
>>> The STROBE_SOURCE_EXTERNAL control state is volatile if a flash device
>>> depends on muxes that route strobe signals to more then one flash
>>> device. In such a case it behaves similarly to FLASH_STROBE control,
>>> i.e. it activates external strobe only for the flash timeout period.
>>> I touched this issue in the cover letter of this patch series,
>>> paragraph 2.
>>
>> I meant that flash->external_strobe is directly used as
>> V4L2_CID_FLASH_STROBE_SOURCE. Are the two guaranteed to be the same?

Yes, the external_strobe sysfs attribute is mapped to it.

Best Regards,
Jacek Anaszewski
