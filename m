Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab3FQKQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:16:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45642 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab3FQKQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:16:41 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-d1-51bee207a72f
Message-id: <51BEE203.6090103@samsung.com>
Date: Mon, 17 Jun 2013 12:16:35 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@linaro.org, tony@atomide.com, balbi@ti.com, arnd@arndb.de,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, rob.herring@calxeda.com, rob@landley.net,
        b-cousson@ti.com, linux@arm.linux.org.uk, benoit.cousson@linaro.org,
        mchehab@redhat.com, cesarb@cesarb.net, davem@davemloft.net,
        rnayak@ti.com, shawn.guo@linaro.org, santosh.shilimkar@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        nsekhar@ti.com
Subject: Re: [PATCH v7 0/9] Generic PHY Framework
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
In-reply-to: <1371113039-5784-1-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t/xq7rsj/YFGryaxmYxZ/0aNou/k46x
	W3y7vYnZ4uD9eouZn26yWcy6FmQx53wLi8WB2Q9ZLQ782cFo0bx4PZvFhac9bBabHl9jtVjY
	toTF4vKuOWwWs5f0s1gsWtbKbHH7Mq/FnqOH2S32925gsnjWv4fR4vCKA0wW615OZ7F43beG
	2eLpuiXMFjemt7Ba7L/i5SDl0dLcw+bx+9ckRo9vXyexeCz4fIXd48jtGcweW1beZPJ4tXom
	q8eda3vYPE7M+M3isX/uGnaPzUvqPc7PWMjo0dv8js3j/b6rbB7Hb2xn8vi8SS5AIIrLJiU1
	J7MstUjfLoEr4/LxR2wFh/kqHi54yNjAeJq7i5GTQ0LAROLTqvUsELaYxIV769m6GLk4hASW
	Mko8PHoTyvnEKHHpCIjDycEroCUx5eBFVhCbRUBVovvRWbA4m4ChRO/RPkYQW1QgQGLxknPs
	EPWCEj8m3wPbIALUe3rnD2aQocwCt1gkfs++yAySEAZqvnHhAxOILSRgI9Fy7xvYUE4BW4n3
	D/aCDWIW0JHY3zqNDcKWl9i85i3zBEaBWUh2zEJSNgtJ2QJG5lWMoqmlyQXFSem5hnrFibnF
	pXnpesn5uZsYIangyw7GxcesDjEKcDAq8fBuqN4XKMSaWFZcmXuIUYKDWUmEN3YiUIg3JbGy
	KrUoP76oNCe1+BAjEwenVAMjx8Zww6fWhwoClpyS7o98eXbJHvY7Fps3F/0KORDA/mTiwvKM
	Z5rbfZ7P6ys4cDe6wPPggkP7IlutHpp3SE+d7ri+9GZ7V9Xf0tdqi9ZdzJt++tGnc7vff0t/
	MfHVuts9kya2KO0U9NXn14hYuejz7WelX76+6b012/3YPe/IZBMTK9n5+a2bipVYijMSDbWY
	i4oTAQW4WPvjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/13/2013 10:43 AM, Kishon Vijay Abraham I wrote:
> Added a generic PHY framework that provides a set of APIs for the PHY drivers
> to create/destroy a PHY and APIs for the PHY users to obtain a reference to
> the PHY with or without using phandle.
> 
> This framework will be of use only to devices that uses external PHY (PHY
> functionality is not embedded within the controller).
> 
> The intention of creating this framework is to bring the phy drivers spread
> all over the Linux kernel to drivers/phy to increase code re-use and to
> increase code maintainability.
> 
> Comments to make PHY as bus wasn't done because PHY devices can be part of
> other bus and making a same device attached to multiple bus leads to bad
> design.
> 
> If the PHY driver has to send notification on connect/disconnect, the PHY
> driver should make use of the extcon framework. Using this susbsystem 
> to use extcon framwork will have to be analysed.
> 
> Making omap-usb2 and twl4030 to use this framework is provided as a sample.
> 
> This patch series is developed on linux mainline tree.
> 
> Changes from v6
> * corrected few typos in Documentation
> * Changed PHY Subsystem to *bool* in Kconfig (to avoid compilation errors when
>   PHY Subsystem is kept as module and the dependent modules are built-in)
> * Added if pm_runtime_enabled check before runtime pm calls.

Looks good, feel free to add:

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com> for patches
1...3/9, 5...7/9

and Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com> for patch 1/9

Hopefully we can gather more Acks and merge it for 3.11.

I have already used this API for our MIPI CSI-2/DSIM DPHYs driver,
the RFC patch series can be found at [1].

Thanks,
Sylwester

[1] http://www.spinics.net/lists/arm-kernel/msg251666.html
