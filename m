Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaLAJfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:35:39 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39545 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaLAJfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:35:37 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-25-547c366680c8
Message-id: <547C3664.9090806@samsung.com>
Date: Mon, 01 Dec 2014 10:35:32 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH/RFC v8 04/14] v4l2-async: change custom.match callback
 argument type
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-5-git-send-email-j.anaszewski@samsung.com>
 <5063831.7WQadZaPHh@avalon>
In-reply-to: <5063831.7WQadZaPHh@avalon>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t/xq7ppZjUhBm9vM1psnLGe1eLozolM
	Fu83zmOyWPJzF5PF2aY37BadE5ewW1zeNYfNYuubdYwWPRu2slosvX6RyeLuqaNsFrt3PWW1
	OPymndXizP6VbA58HmvmrWH0mPJ7I6vHzll32T0+fIzzmN0xk9Xj8NeFLB575v9g9ejbsorR
	Y8Xq7+wenzfJBXBFcdmkpOZklqUW6dslcGWc73ArOM5T8evlA7YGxulcXYwcHBICJhLvj4Z1
	MXICmWISF+6tZ+ti5OIQEljKKPFwfiMrhPORUeLBmXmMIFW8AloSu3e8ZgGxWQRUJZ4vu8gM
	YrMJGEr8fPGaCcQWFYiQ+HN6HytEvaDEj8n3wOpFBCwkehdNB5vDLPCVSWLaC08QW1ggSuLw
	zNmMcJsvNTawgyQ4BTQkjqw8wArRYC2xctI2qGZ5ic1r3jJPYBSYhWTHLCRls5CULWBkXsUo
	mlqaXFCclJ5rqFecmFtcmpeul5yfu4kREltfdjAuPmZ1iFGAg1GJh/fCquoQIdbEsuLK3EOM
	EhzMSiK80w1qQoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUw+uyxDCnYJcNl8M5W7If1yTfSTfzv
	Inysq5/E+u3/2r2Lh6OjsWvTjU3zmDe1SwdytGQsEOnx/6/vErr1dbaKwoVDaQl/lbNlwuKe
	3W377NdRvvySVPbz+RlnktizlVO3Onye885kQqdf3nqWy3LPFj16d3iiTfyGFLtnM2JYXNtE
	fA4dXXVSiaU4I9FQi7moOBEAgMgZoosCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On 11/29/2014 05:38 PM, Laurent Pinchart wrote:
> Hi Jacek,
>
> Thank you for the patch.
>
> On Friday 28 November 2014 10:17:56 Jacek Anaszewski wrote:
>> It is useful to have an access to the async sub-device
>> being matched, not only to the related struct device.
>> Change match callback argument from struct device
>> to struct v4l2_subdev. It will allow e.g. for matching
>> a sub-device by its "name" property.
>
> In principle I agree. However, we will need to reimplement v4l2-async based on
> the component (drivers/base/component.c) framework at some point. As the
> component framework is based on struct device, will it still be possible to
> match on subdev name in that case ? If not, we might need to try to find
> another approach to the issue.

There were reservations raised [1] concerning the way of matching
by name, as the labels are not guaranteed to be globally unique across
Device Tree. I admit, this issue has to be solved in a different way.
Especially in view of prospective transition to using
drivers/base/component.c

I propose to add a new structure:

struct v4l2_asd_match{
	bool (*match)(struct v4l2_async_subdev *, void *);
	void *priv;
}

and a function:
v4l2_async_register_subdev_with_match(struct v4l2_subdev *sd, struct 
v4l2_asd_match*).

This way we could pass DT sub-node related to a sub-led in a priv
field of v4l2_asd_match upon registration.

This is similar approach as in case of drivers/base/component.c.

Best Regards,
Jacek Anaszewski

[1] http://www.spinics.net/lists/linux-leds/msg02532.html
