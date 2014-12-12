Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030347AbaLLNvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:51:49 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20665 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030330AbaLLNvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:51:46 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-12-548af2ef526d
From: Krzysztof Opasiak <k.opasiak@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, peter.chen@freescale.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
Subject: RE: [PATCH] usb: gadget: udc-core: call udc_stop() before gadget unbind
Date: Fri, 12 Dec 2014 14:51:42 +0100
Message-id: <02eb01d01612$c35319d0$49f94d70$%opasiak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAWDgJwjcoP7WMkT4qWo8AdBkGU0QABCf4g
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xK7rvP3WFGFx/rGZx8H69RfPi9WwW
	l3fNYbNYtKyV2WLtkbvsFsdm/2WyeHB4J7sDu8e/w/1MHvvnrmH36NuyitHj+I3tTB6fN8kF
	sEZx2aSk5mSWpRbp2yVwZSxodyq4zl2x8tU81gbG85xdjJwcEgImEo9ON7JC2GISF+6tZ+ti
	5OIQEljKKPH23GlGCKeBSaJn7wGgKg4ONgF9iXm7REEaRAQsJO7vPcoGYjMLLGKUuL7dC6RE
	SMBF4vKcIhCTU8BV4vAVFZAKYYEAia2zZrKD2CwCqhIdDzczg5TwCjhK3LwrABLmFRCU+DH5
	HgvEQC2JzduaWCFseYnNa96ClUsIqEs8+qsLsd9I4sLvpVD7RSTuNjxnncAoNAvJpFlIJs1C
	MmkWkpYFjCyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUIi5MsOxsXHrA4xCnAwKvHwvkjt
	ChFiTSwrrsw9xCjBwawkwvs3CijEm5JYWZValB9fVJqTWnyIkYmDU6qB0WCrvtiOqWlze5Ps
	1J3VWWeYJJ57sOBMnFLdSZ2JNlmxk30iDgY9u5EwKZXvvK5Wyumjb75vSpzapadUP5Nlrrva
	TZOKnne6fXZL1oo4z9YwbanV/86eNHf1uwlz9hQb9jnkpNXH7Dqtfqiu6oy3g13UcxdXqf/5
	W3d4Fec88is3Lpn2/penEktxRqKhFnNRcSIAc7/Ism4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
> Sent: Friday, December 12, 2014 2:17 PM
> To: balbi@ti.com
> Cc: gregkh@linuxfoundation.org; peter.chen@freescale.com; linux-
> usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> m.szyprowski@samsung.com; k.opasiak@samsung.com; Robert Baldyga
> Subject: [PATCH] usb: gadget: udc-core: call udc_stop() before
> gadget unbind
> 
> As usb function drivers assumes that all usb request will be
> completed
> before function unbind call, we should supply such behavior. In
> some
> cases ep_disable() won't kill all request effectively, because some
> IN requests can be in running state. In such situation it's
> possible
> to have unbind function called before last request completion,
> which
> can cause problems.
> 
> For example unbinding f_ecm function while request on 'notify'
> endpoint
> is not completed, ends up NULL pointer dereference in unbind()
> function.
> 
> usb_gadget_udc_stop() call causes completion of all requests so if
> it's
> called before gadget unbind there is no risk that some of requests
> will
> stay uncompleted.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

This finally solves issue described before in [1]

Tested-by: Krzysztof Opasiak <k.opasiak@samsung.com>

Footnotes:
1 - https://lkml.org/lkml/2014/12/9/283

-- 
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
k.opasiak@samsung.com




