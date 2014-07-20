Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaGTN5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 09:57:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:38778 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaGTN5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 09:57:40 -0400
Message-ID: <53CBCB5D.1050902@kernel.org>
Date: Sun, 20 Jul 2014 14:59:57 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
CC: Sachin Kamat <spk.linux@gmail.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>, cpgs@samsung.com,
        Grant Grundler <grundler@chromium.org>
Subject: Re: [PATCH 1/4 v2] iio: exyno-adc: use syscon for PMU register access
References: <1405595993-16661-1-git-send-email-ch.naveen@samsung.com> <CAK5sBcFR0nwmL97CYxhHHhwHREdNOMYZnc2DF+O=WdQLBHQbLA@mail.gmail.com> <CAHfPSqDBfdmt2R4yB1AUG9U8UvsYtmVtL03-OMuozKGXYGdMgw@mail.gmail.com> <4202302.OdUuvHROuH@amdc1032>
In-Reply-To: <4202302.OdUuvHROuH@amdc1032>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/14 14:56, Bartlomiej Zolnierkiewicz wrote:
>
> Hi,
>
> On Thursday, July 17, 2014 05:41:16 PM Naveen Krishna Ch wrote:
>> Hello Sachin,
>>
>> On 17 July 2014 17:24, Sachin Kamat <spk.linux@gmail.com> wrote:
>>> Hi Naveen,
>>>
>>> On Thu, Jul 17, 2014 at 4:49 PM, Naveen Krishna Chatradhi
>>> <ch.naveen@samsung.com> wrote:
>>>> This patch updates the IIO based ADC driver to use syscon and regmap
>>>> APIs to access and use PMU registers instead of remapping the PMU
>>>> registers in the driver.
>>>>
>>>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>>> To: linux-iio@vger.kernel.org
>>>
>>> With only this patch applied, I believe the ADC functionality would be broken.
>>> Perhaps the DT changes should be merged along with this patch?
>>
>> Jonathan already mentioned that, he would wait for Ack from Kukjin.
>> With out the dts changes ADC driver will fail to probe but it wont
>> crash the system.
>> git bisect should still work.
>
> Unless someone bisects things related to ADC functionality..
>
> Also patch #1 seems to break device tree ABI (the old dtb will no longer
> work with the new kernel).
A very good point.  How to avoid this breakage?  Supporting the whole
old mechanism is going to be a little painful but without that phandle
is there any other way?
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

