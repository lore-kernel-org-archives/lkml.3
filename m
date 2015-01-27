Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbbA0LdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:33:08 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36149 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbbA0LdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:33:04 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-83-54c776dd0a48
Message-id: <54C77762.9090807@samsung.com>
Date: Tue, 27 Jan 2015 12:32:50 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: "Baluta, Teodora" <teodora.baluta@intel.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 0/3] Introduce IIO interface for fingerprint sensors
References: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
 <5481153B.4070609@kernel.org> <1418047828.18463.10.camel@bebop>
 <54930604.1020607@metafoo.de> <549D42BD.1050901@kernel.org>
 <1421255642.31900.4.camel@bebop> <54B7FAF2.8080207@samsung.com>
 <A2E3DE9C026DE6469D89C3A4C6C219390A89FE37@IRSMSX107.ger.corp.intel.com>
In-reply-to: <A2E3DE9C026DE6469D89C3A4C6C219390A89FE37@IRSMSX107.ger.corp.intel.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7p3y46HGNxab25xavIzJosHTauY
	LJZMns9qMe/IOxaLy7vmsFn0bNjKanFxnbzF2TM3mBw4PBbvecnksWlVJ5vHkjeHWD36tqxi
	9Pi8Sc7j1NfP7AFsUVw2Kak5mWWpRfp2CVwZO0/PYiyYLVxxdOpbtgbGv3xdjJwcEgImEmde
	3mSFsMUkLtxbz9bFyMUhJLCUUWLll+/sEM4nRolDK9YAORwcvAJaEisPKYE0sAioSly895cJ
	xGYTMJToPdrHCGKLCkRInLy7hx3E5hUQlPgx+R4LiC0iEC6xZ9NDsAXMAm1MEhf2nAIrEhbw
	kdh/6TVYkZDAFSaJww2yIDanQJjEh5bTTCB7mQXUJaZMyQUJMwvIS2xe85Z5AqPALCQrZiFU
	zUJStYCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSNB/2cG4+JjVIUYBDkYlHl6OouMh
	QqyJZcWVuYcYJTiYlUR4vSKAQrwpiZVVqUX58UWlOanFhxiZODilGhjbnrtqfZDPfWkz+2vW
	q2NKK9vrWWcFO3l+eaSpdVL7FvPd6Ql3ve4pL8k02hDWprhsssiLKWLzrcudb673cr34QuWg
	w7/N9o+zecOEV+anyXhdyul8w+N+VNnuz7EpcfcNRa57N7VEcn2aetRg4r2lYTn3n4bLCGsx
	yujxd56Jm+d6Sq3shKoSS3FGoqEWc1FxIgATgPJjWAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 23/01/15 14:05, Baluta, Teodora wrote:
...
>>>>>>> So why not v4l?  These are effectively image sensors..
>>>>>>
>>>>>> Well, here's why I don't think v4l would be the best option:
>>>>>>
>>>>>> - an image scanner could be implemented in the v4l subsystem, but
>>>>>> it seems far more complicated for a simple fingerprint scanner - it
>>>>>> usually has drivers for webcams, TVs or video streaming devices.
>>>>>> The v4l subsystem (with all its support for colorspace, decoders,
>>>>>> image compression, frame control) seems a bit of an overkill for a
>>>>>> very straightforward fingerprint imaging sensor.
>>>
>>>> Whilst those are there, I would doubt the irrelevant bits would put
>>>> much burden on a fingerprint scanning driver.  Been a while since I
>>>> did anything in that area though so I could be wrong!
>>
>> IMO V4L is much better fit for this kind of devices than IIO. You can use just a
>> subset of the API, it shouldn't take much effort to write a simple
>> v4l2 capture driver, supporting fixed (probably vendor/chip specific) image
>> format.  I'm not sure if it's better to use the v4l2 controls [1], define a new
>> v4l2 controls class for the fingerprint scanner processing features, rather than
>> trying to pass raw data to user space and interpret it then in some library.  I
>> know there has been resistance to allowing passing unknown binary blobs to
>> user space, due to possible abuses.
>>
>> [1] Documentation/video4linux/v4l2-controls.txt
>                                                                                                                
> The fingerprint sensor acts more like a scanner device, so the closest type 
> is the V4L2_CAP_VIDEO_CAPTURE. However, this is not a perfect match because
> the driver only sends an image, once, when triggered. Would it be a better
> alternative to define a new capability type? Or it would be acceptable to
> simply have a video device with no frame buffer or frame rate and the user
> space application to read from the character device /dev/videoX?

I don't think a new capability is needed for just one buffer capture.
The capture driver could just support read() and signal it by setting the
V4L2_CAP_READWRITE capability flag [2], [3].

[2]
http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-querycap.html#device-capabilities
[3] http://linuxtv.org/downloads/v4l-dvb-apis/io.html#rw

--
Regards,
Sylwester
