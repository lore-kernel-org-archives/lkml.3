Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaLHQz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:55:28 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39382 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbaLHQzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:55:24 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a8-5485d7f91380
Message-id: <5485D7F8.10807@samsung.com>
Date: Mon, 08 Dec 2014 17:55:20 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Bryan Wu <cooloney@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v8 02/14] Documentation: leds: Add description of LED
 Flash class extension
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-3-git-send-email-j.anaszewski@samsung.com>
 <20141129125832.GA315@amd> <547C539A.4010500@samsung.com>
 <20141201130437.GB24737@amd> <547C7420.4080801@samsung.com>
 <CAK5ve-KMNszyz6br_Q_dOhvk=_8ev6Uz-ZhPnYBn-ZvuohQpVA@mail.gmail.com>
 <20141206124310.GB3411@amd>
In-reply-to: <20141206124310.GB3411@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t/xa7o/r7eGGHz8om2xccZ6VoujOycy
	WZxtesNucXnXHDaLrW/WMVr0bNjKanH31FE2i927nrJaHH7TzmpxZv9KNgcuj52z7rJ7HP66
	kMVjz/wfrB59W1YxeqxY/Z3d4/MmuQC2KDebjNTElNQihdS85PyUzLx0W6XQEDddCyWFvMTc
	VFulCF3fkCAlhbLEnFIgz8gADTg4B7gHK+nbJbhlPHq9i7XgKXfFjjdTmBoYl3N2MXJySAiY
	SFz4/JgRwhaTuHBvPVsXIxeHkMBSRonGz28YIZyPjBL7j98Dq+IV0JD40NzI3sXIwcEioCpx
	/p49SJhNwFDi54vXTCC2qECExJ/T+1ghygUlfky+xwJiiwjIS2ztW8EMMpNZoIFZ4uHyp2wg
	CWGBVIk3b/6BzRcSeMYksfqKJYjNCbTr4MadYM3MAtYSKydtY4Sw5SU2r3nLPIFRYBaSHbOQ
	lM1CUraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkgcft3BuPSY1SFGAQ5GJR7eDeXN
	IUKsiWXFlbmHGCU4mJVEeJfvbA0R4k1JrKxKLcqPLyrNSS0+xJgMDIGJzFKiyfnAFJFXEm9o
	YmhuaWhkbGFhbmREmrCSOG/l15YQIYH0xJLU7NTUgtQimC1MHJxSDYypoWc1liddmfPmo/nj
	s867tyUtLTuhXVHzcs5Nv5tbpO2qF23XT18k97ZyWal2xVrVnfllbbKPN4uoKE1+1sBiEdbq
	5PNjTm+yVvbbOvmFhdu+dzdNXysnYBVvHPdMX6Xinquc+evsSP6lDPozVC3OVVgwFXl0tgqw
	C3/8ztBitpW7JMzptRJLcUaioRZzUXEiAMTg9+YHAwAA
X-MTR: 20000000000000000@CPGS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2014 01:43 PM, Pavel Machek wrote:
>
>>> The format of a sysfs attribute should be concise.
>>> The error codes are generic and map directly to the V4L2 Flash
>>> error codes.
>>>
>>
>> Actually I'd like to see those flash fault code defined in LED
>> subsystem. And V4L2 will just include LED flash header file to use it.
>> Because flash fault code is not for V4L2 specific but it's a feature
>> of LED flash devices.
>>
>> For clearing error code of flash devices, I think it depends on the
>> hardware. If most of our LED flash is using reading to clear error
>> code, we probably can make it simple as this now. But what if some
>> other LED flash devices are using writing to clear error code? we
>> should provide a API to that?
>
> Actually, we should provide API that makes sense, and that is easy to
> use by userspace.
>
> I believe "read" is called read because it does not change anything,
> and it should stay that way in /sysfs. You may want to talk to sysfs
> maintainers if you plan on doing another semantics.

How would you proceed in case of devices which clear their fault
register upon I2C readout (e.g. AS3645)? In this case read does have
a side effect. For such devices attribute semantics would have to be
different than for the devices which don't clear faults on readout.

In case of devices which use writing to clear error code - I'd do that
after reading flash_fault attribute, in the same callback.

Best Regards,
Jacek Anaszewski

