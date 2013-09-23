Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3IWI0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:26:48 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:47605 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171Ab3IWI0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:26:46 -0400
Message-ID: <523FFB2C.1090400@st.com>
Date: Mon, 23 Sep 2013 13:56:20 +0530
From: Ajit Pal Singh <ajitpal.singh@st.com>
Reply-To: <ajitpal.singh@st.com>
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: Re: [PATCH] thermal: st: Add support for STiH41x thermal sensors
References: <ajitpal.singh@st.com> <1379497103-5657-1-git-send-email-ajitpal.singh@st.com> <523A06EE.9090801@ti.com>
In-Reply-To: <523A06EE.9090801@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 September 2013 01:32 AM, Eduardo Valentin wrote:
> On 18-09-2013 05:38, Ajit Pal Singh wrote:
>> Adds support for thermal sensors on STiH41x series SOCs.
>> Single trip point 'THERMAL_TRIP_CRITICAL' is supported.
>> STIH416 MPE sensor supports interrupt reporting when a preset
>> threshold temperature is crossed.
>> For rest of the thermal sensors a polling delay of 10000ms is
>> set.
>>
>> CC: Stephen Gallimore <stephen.gallimore@st.com>
>> CC: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
[snip]
>> +static irqreturn_t st_thermal_thresh_int(int irq, void *data)
>> +{
>> +	struct st_thermal_sensor *sensor = data;
>> +	struct device *dev = sensor_to_dev(sensor);
>> +
>> +	dev_dbg(dev, "%s,called\n", __func__);
>> +	thermal_zone_device_update(sensor->th_dev);
>
> Are you sure you want to do this here? The above call might sleep.

Have used devm_request_threaded_irq() to register the above threaded irq 
handler. Calling sleep-able calls from the threaded interrupt handler 
should be OK ?
>
>> +	return IRQ_HANDLED;
>> +}
[snip]
>> +static int st_thermal_notify(struct thermal_zone_device *th,
>> +			       int trip, enum thermal_trip_type type)
>> +{
>> +	struct st_thermal_sensor *sensor = thzone_to_sensor(th);
>> +	struct device *dev = sensor_to_dev(sensor);
>> +
>> +	switch (type) {
>> +	case THERMAL_TRIP_CRITICAL:
>> +		/* TODO: Send event to user space */
>
> It depends on what you mean by that. The core code will attempt to call
> the shutdown command, in user space.

Will remove the comment in the next version of the patch.
>
>> +		dev_err(dev, "Critical temp reached:Going for shutdown\n");
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +	return 0;
>> +}
>> +
[snip]
>> +module_platform_driver(st_thermal_driver);
>> +MODULE_AUTHOR("STMicroelectronics (R&D) Limited");
>> +MODULE_DESCRIPTION("STMicroelectronics STIH41x SOC thermal sensor driver");
>> +MODULE_LICENSE("GPL");
>
> GPL v2?

OK.Will make it GPLv2
>

Thanks
Ajit Pal Singh

