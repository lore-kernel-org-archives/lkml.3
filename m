Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab3GVHqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 03:46:36 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.1]:54526 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186Ab3GVHqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 03:46:35 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-3.tower-29.messagelabs.com!1374479192!23614666!4
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <51ECE34E.7050904@digi.com>
Date: Mon, 22 Jul 2013 09:46:22 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2 3/5] iio: mxs-lradc: add scale attribute to channels
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com> <201307191814.15491.marex@denx.de> <51ECDD9F.4080506@digi.com> <201307220942.08990.marex@denx.de>
In-Reply-To: <201307220942.08990.marex@denx.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On 07/22/2013 09:42 AM, Marek Vasut wrote:
> Dear Hector Palacios,
>
>> Hi Marek,
>>
>> On 07/19/2013 06:14 PM, Marek Vasut wrote:
>>> Dear Hector Palacios,
>>>
>>>> Dear Marek,
>>>>
>>>> On 07/19/2013 04:30 PM, Marek Vasut wrote:
>>>>>> @@ -228,39 +230,12 @@ struct mxs_lradc {
>>>>>>
>>>>>>     #define LRADC_RESOLUTION			12
>>>>>>     #define LRADC_SINGLE_SAMPLE_MASK		((1 << LRADC_RESOLUTION)
> - 1)
>>>>>>
>>>>>> -/*
>>>>>> - * Raw I/O operations
>>>>>> - */
>>>>>> -static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>>>>>> +static int mxs_lradc_read_single(struct iio_dev *iio_dev,
>>>>>>
>>>>>>     			const struct iio_chan_spec *chan,
>>>>>>     			int *val, int *val2, long m)
>>>>>>
>>>>>>     {
>>>>>>
>>>>>>     	struct mxs_lradc *lradc = iio_priv(iio_dev);
>>>>>>     	int ret;
>>>>>>
>>>>>> -	unsigned long mask;
>>>>>> -
>>>>>> -	if (m != IIO_CHAN_INFO_RAW)
>>>>>> -		return -EINVAL;
>>>>>> -
>>>>>> -	/* Check for invalid channel */
>>>>>> -	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
>>>>>> -		return -EINVAL;
>>>>>
>>>>> This was already resolved, so this patch won't apply I'm afraid.
>>>>
>>>> You mean the 'unsigned long mask', right?  Yeah, I think I had resolved
>>>> that one before submitting, but looks like I didn't.
>>>> The other check is not resolved afaik. We agreed to remove it, but on a
>>>> different patch.
>>>
>>> I mean the other check, yeah. A patch removing that should be applied
>>> already.
>>
>> Where exactly? It's not fixed in Jonathan's fixes-togreg branch, at least.
>> Did you fixed it?
>
> I use linux-next [1], should be it.
>
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-
> next.git/log/drivers/staging/iio/adc/mxs-lradc.c

That is removing the unsigned long mask, but not the check for invalid channel.
I'm taking care of the unsigned long mask but an additional patch is needed to remove 
the check for invalid channel.

Best regards,
--
Hector Palacios
