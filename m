Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbbALJbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:31:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28718 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbbALJbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:31:33 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-0d-54b39473944d
Message-id: <54B39472.4000303@samsung.com>
Date: Mon, 12 Jan 2015 10:31:30 +0100
From: Karol Wrona <k.wrona@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-iio@vger.kernel.org, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH 1/2] iio: Add no-triggered buffer helper functions
References: <1420735227-21091-1-git-send-email-k.wrona@samsung.com>
 <1420735227-21091-2-git-send-email-k.wrona@samsung.com>
 <54B108A9.7080307@metafoo.de> <54B16DD3.3030505@kernel.org>
In-reply-to: <54B16DD3.3030505@kernel.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xq7rFUzaHGGzfIGWxccZ6VosHTauY
	LHb9f8NscbbpDbvFksnzWS3mHXnHYnF51xw2i9+7jrFb7Fm3hcmB02PnrLvsHh8+xnlsWtXJ
	5rHkzSFWj/PNRxg9+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK2PO/D2MBVsEK9ZN2MPSwPiC
	t4uRk0NCwESicf56RghbTOLCvfVsXYxcHEICSxkl7j5ezAThfGKU+LZhPytIFa+AlsSXNXvB
	OlgEVCVeLrjLBmKzCahLNO9YzAxiiwpESFxZM4cRol5Q4sfkeywgtojABUaJmZ2qIEOZBdoZ
	Je5vOs8OkhAWcJO4uOE4K8S23YwSp9ZfBZrEwcEJtG3CQgkQk1lAT+L+RS2QcmYBeYnNa94y
	T2AUmIVkxSyEqllIqhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImFLzsYFx+zOsQo
	wMGoxMM7QWZziBBrYllxZe4hRgkOZiURXtcyoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGuhZf
	nilzZlnN/fGOyd98Hl9HbGzlCc+4A6tKNONUTid2le1dz7XEXWW2qoZRq3zq1PWTrOfd23pD
	6VxuTUzB2ZjzG+/ofGx6LTBx75OurXOyXK3mmnyVSLrCZJAr6DOdk73uTdjtFosDhttX7q73
	e7+pJO5U54+js4/ect/mpmLjUsHz1n6VEktxRqKhFnNRcSIAfiu0SWMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2015 07:22 PM, Jonathan Cameron wrote:
> On 10/01/15 11:10, Lars-Peter Clausen wrote:
>> On 01/08/2015 05:40 PM, Karol Wrona wrote:
>>> These ones helps to create and manage iio_kfifo buffer when
>>> no-triggered buffer is used.
>> [...]
>>> +int iio_notriggered_buffer_setup(struct iio_dev *indio_dev,
>>> +                 const struct iio_buffer_setup_ops *setup_ops)
>>> +
>>> +{
>>> +    int ret;
>>> +    struct iio_buffer *buffer;
>>> +
>>> +    buffer = iio_kfifo_allocate();
>>> +    if (!buffer)
>>> +        return -ENOMEM;
>>> +
>>> +    iio_device_attach_buffer(indio_dev, buffer);
>>> +
>>> +    indio_dev->setup_ops = setup_ops;
>>> +
>>> +    ret = iio_buffer_register(indio_dev, indio_dev->channels,
>>> +                  indio_dev->num_channels);
>>> +    if (ret)
>>> +        iio_kfifo_free(buffer);
>>> +
>>
>> We recently got rid of having to manually call iio_buffer_register() and iio_buffer_unregister(). This is now done by the IIO core. See http://git.kernel.org/cgit/linux/kernel/git/jic23/iio.git/commit/?h=togreg&id=3e1b6c95b990c93f4aa3b17e9f66221e2fa44bee
>>
>> I don't think we actually need these non-triggered helper functions anymore. It basically just boils down to iio_kfifo_allocate() and iio_device_attach_buffer().
>>
> Even if they are still worthwhile, I'd just put them in the core code rather
> than having the additional module.  Too trivial for it to make sense
> in a utility module.
> 
> I'm inclined to agree with Lars that the recent changes reduce the argument for
> having these to marginal at best.  Bad luck for crossing with those!
> 
> Jonathan
> 
> J
>> - Lars

No problem with dropping that. I prefer to be done this way too as now cleanup
wrapper has no sense at all.

Thanks
Karol


>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

