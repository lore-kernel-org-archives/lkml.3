Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaDRL2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 07:28:06 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12793 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDRL2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 07:28:01 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-44-53510c3ebe67
Message-id: <53510C39.1020205@samsung.com>
Date: Fri, 18 Apr 2014 13:27:53 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: dri-devel@lists.freedesktop.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 3/3] drm/exynos: use pending_components for	components
 tracking
References: <1397734130-21019-1-git-send-email-a.hajda@samsung.com>
 <1397734130-21019-4-git-send-email-a.hajda@samsung.com>
 <20140417214709.GY24070@n2100.arm.linux.org.uk>
In-reply-to: <20140417214709.GY24070@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/xa7p2PIHBBmv+m1v0njvJZPF30jF2
	iytf37NZNC9ez2Yx6f4EFouzTW/YLTY9vsZqcXnXHDaLGef3MVncvsxrsfbIXXaL9TNeszjw
	eLQ097B5/P41idFj+7cHrB77565h97jffZzJY/OSeo++LasYPT5vkgvgiOKySUnNySxLLdK3
	S+DKeLp4B3vBQu6K/w26DYz/OLoYOTkkBEwkmoEugbDFJC7cW8/WxcjFISSwlFHiy99FTBDO
	J0aJ1+tbGEGqeAW0JD62fQezWQRUJaZ/fwFmswloSvzdfJMNxBYViJC413iYFaJeUOLH5Hss
	ILaIgKnEtUfPmEGGMgs0sUjMuToDLCEsECmxcu8qMFtIYD2jxO7ddSA2p4CNxLJVh8CGMgvo
	SOxvnQZly0tsXvOWeQKjwCwkO2YhKZuFpGwBI/MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxN
	jJCY+bqDcekxq0OMAhyMSjy8F776BwuxJpYVV+YeYpTgYFYS4d39NyBYiDclsbIqtSg/vqg0
	J7X4ECMTB6dUA+P1hUl3Ewwu9e4RN3pce77paX/ay/nxB9O+WvolWdukrV04Jcj7w9pfxu63
	95qLuX56FcFdP+NcE8v61rcvTX53K8csnHh1nSXvR0mtdZp71WK1LsxfZ7PK3TBtxZ2kWxPP
	10ReqlN5Zvm1WzSjcO4x2Q6m73+dypptKoKAdjerXmi71scWrcRSnJFoqMVcVJwIAGXwi2h3	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel,

Thanks for comments.

On 04/17/2014 11:47 PM, Russell King - ARM Linux wrote:
> On Thu, Apr 17, 2014 at 01:28:50PM +0200, Andrzej Hajda wrote:
>> +out:
>> +	if (ret != -EPROBE_DEFER)
>> +		exynos_drm_dev_ready(&pdev->dev);
> So we end up with everyone needing a "ready" call in each sub-driver
> back into the main driver... this makes it impossible to write a
> generic subcomponent driver which is not tied in any way to the
> main driver.
>
> That is quite some restriction, and would prevent, for example, the
> TDA998x driver being used both with Armada DRM, tilcdc and any other
> driver.

As I see in armada driver drm is deferred in case tda998x is not yet
available. The same solution can be still used with pending_devices
approach - the main driver will not report its readiness until tda998x
is present.

Anyway it still seems to be better than componentize every driver which can
probably become a part of some superdevice.

If you want to get rid of deferred probe one can make global list of
'ready' devices with notifications systems for master devices.

Maybe it would be good to consider notification system for devices probe
result,
it will require that driver register all its interfaces in probe, ie its
readiness cannot
be reported later but will not require to add new framework. I hope just
extending current
notification system should be enough.

Regards
Andrzej

