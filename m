Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaBKRWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:22:45 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42162 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaBKRWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:22:43 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-df-52fa5c601a81
Message-id: <52FA5C5A.1090008@samsung.com>
Date: Tue, 11 Feb 2014 18:22:34 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
 <CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
 <20140211145248.GI26684@n2100.arm.linux.org.uk> <8648675.AIXYyYlgXy@avalon>
 <1392136617.6943.33.camel@pizza.hi.pengutronix.de>
In-reply-to: <1392136617.6943.33.camel@pizza.hi.pengutronix.de>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t/xK7oJMb+CDP6fUbGYf+Qcq8X7jfOY
	LA782cFocbbpDbtF58Ql7BaXd81hs+jZsJXV4vZlXouL6+Qt7t47wWKxdd45RovWvUfYLb5/
	+8ZmsX7+LTYHPo+W5h42j52z7rJ7fPgY5zG7Yyarx6ZVnWwed67tYfPo/2vg0bdlFaPH8Rvb
	mTw+b5IL4IrisklJzcksSy3St0vgymhYv5+poE2g4mf/fKYGxi7eLkZODgkBE4mGJ6uYIGwx
	iQv31rN1MXJxCAksZZRYtPcTE4TziVFiyaVTLCBVvAJaErfmzAazWQRUJe69XA5mswkYSvQe
	7WMEsUUFIiRenZ0IVS8o8WPyPTBbRCBJ4tWMp2AbmAVOsEh8Xr4PLCEskCqx9vBtVohtE5gk
	Wo5OAbuJU8BeYvu97WwgNrOAusSkeYuYIWx5ic1r3jJPYBSYhWTJLCRls5CULWBkXsUomlqa
	XFCclJ5rqFecmFtcmpeul5yfu4kREltfdjAuPmZ1iFGAg1GJh5fB81eQEGtiWXFl7iFGCQ5m
	JRFeNTWgEG9KYmVValF+fFFpTmrxIUYmDk6pBsYZS1qc/3G9mae6aXqP0iGurTJ/lp/J4GFZ
	1d0936tMn1dUg9HeRPjyj+VeRcnKKeoT/XcYt/eUbdmwx8LZ+OPfbSHPdWX/9Mz5+npF8scb
	h/K3Lwpze8ouljv9SGAMf877juQZ8xc1OZ3pEv025fOivKpLLn+SDj08dHnlt33pS1Y+sFSN
	n5yhxFKckWioxVxUnAgA0pOzHYsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Guennadi to Cc)

On 11/02/14 17:36, Philipp Zabel wrote:
> Am Dienstag, den 11.02.2014, 16:23 +0100 schrieb Laurent Pinchart:
>> Hi Russell,
>>
>> On Tuesday 11 February 2014 14:52:48 Russell King - ARM Linux wrote:
>>> On Tue, Feb 11, 2014 at 07:56:33AM -0600, Rob Herring wrote:
>>>> On Tue, Feb 11, 2014 at 5:45 AM, Philipp Zabel wrote:
>>>>> This allows to reuse the same parser code from outside the V4L2
>>>>> framework, most importantly from display drivers. There have been
>>>>> patches that duplicate the code (and I am going to send one of my own),
>>>>> such as
>>>>> http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
>>>>> and others that parse the same binding in a different way:
>>>>> https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html
>>>>>
>>>>> I think that all common video interface parsing helpers should be moved
>>>>> to a single place, outside of the specific subsystems, so that it can
>>>>> be reused by all drivers.
>>>>
>>>> Perhaps that should be done rather than moving to drivers/of now and
>>>> then again to somewhere else.
>>>
>>> Do you have a better suggestion where it should move to?
>>>
>>> drivers/gpu/drm - no, because v4l2 wants to use it
>>> drivers/media/video - no, because DRM drivers want to use it
>>> drivers/video - no, because v4l2 and drm drivers want to use it
>>
>> Just pointing out a missing location (which might be rejected due to similar 
>> concerns), there's also drivers/media, which isn't V4L-specific.
> 
> Since drivers/Makefile has media/ in obj-y, moving the graph helpers to
> drivers/media should technically work.
> 
>>> Maybe drivers/of-graph/ ?  Or maybe it's just as good a place to move it
>>> into drivers/of ?
> 
> include/media/of_graph.h,
> drivers/media/of_graph.c?

drivers/media sounds like a good alternative to me.

I would just remove also v4l2_of_{parse/get}* and update the users
to call of_graph_* directly, there should not be many of them.

--
Thanks,
Sylwester

