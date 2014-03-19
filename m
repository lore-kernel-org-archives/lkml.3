Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965080AbaCSRaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:30:30 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31698 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaCSRa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:30:27 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-17-5329d42be29d
Message-id: <5329D426.9020706@samsung.com>
Date: Wed, 19 Mar 2014 18:30:14 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Grant Grundler <grundler@chromium.org>
Cc: Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 17/27] iommu/exynos: remove calls to Runtime PM API
 functions
References: <20140314140843.ba055f28dd7ed59c46088029@samsung.com>
 <5322FD14.5090602@samsung.com>
 <20140318185605.0380c8dfe6559c06183092e5@samsung.com>
 <532861BE.7020601@samsung.com>
 <20140319100304.5e26fa43ccdfc29178b058e1@samsung.com>
 <532997D7.6090608@samsung.com>
 <CANEJEGuYz28dGT+264CYtG+Tk6htOq=u-t4PWMtsij32X0vJFA@mail.gmail.com>
In-reply-to: <CANEJEGuYz28dGT+264CYtG+Tk6htOq=u-t4PWMtsij32X0vJFA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e/4ZV3tK5rBBkePGVrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S3+9R5ktJiy6DCrxeE3
	7awWJ//0MlrMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MqY/egfS8FfnopZG7UbGHdwdTFyckgImEg0/p7IBmGL
	SVy4tx7MFhJYyigx+Zp0FyMXkP2ZUWLZxn3MIAleAS2J9ZuPMHUxcnCwCKhKLJ4RChJmE1CT
	+NzwCKyXH6hkTdN1FhBbVCBCYu7EzWwQrYISPybfA4uLANXM2H+OFcRmFvjPInF2qzuILSwQ
	LnHqxkcWiBtuM0nM25wGYnMKBEvc3XWNGaLeTOJRyzooW15i85q3zBMYBWchWTELSdksJGUL
	GJlXMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoRE29cdjEuPWR1iFOBgVOLhXbFHM1iINbGs
	uDL3EKMEB7OSCO8rkBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG5ROSoiVTT+97LOGlF9kVWlbg
	ERRtL5lav6hrlvC8BbvaHOsTXLq9bXkEIwT+Ho3eZpt2NnCC7Hf/BRHlO68nNZdduu+5Y6m+
	S7j4FcXrnx+/VNU79UqqTWaR5byZNqlpdQYn/dwWOfc032oomD2Rc0eG1mQnn32SBQGhuUfT
	X0WEhXX9mq7EUpyRaKjFXFScCADeKmlZlAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 19.03.2014 18:03, Grant Grundler wrote:
> On Wed, Mar 19, 2014 at 6:12 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> ...
>> No. Proper Linux drivers must support deferred probing mechanism and there
>> should be no assumptions about probing orders. Using other initcall level
>> than module_initcall for particular drivers is strongly discouraged.
>
> That's true for "end-point" devices. It's not true for
> "infrastructure": Memory, CPU, DMA, Interrupt handling, etc. Those
> need to be in place before "normal" drivers get called. This SysMMU
> driver provides DMA services for "normal" device drivers. Or do I see
> that wrong?

Of course using an early initcall level would give you some kind of 
guarantees, but it wouldn't guarantee that someone couldn't lower 
initcall level for some MMU client driver and break the ordering anyway.

As I said, AFAIK the trend is to get rid of ordering by initcalls and 
make sure that drivers can handle missing dependencies properly, even 
for "services" such as DMA, GPIO, clocks and so on, which after all are 
provided by normal drivers like other.

>
> thanks,
> grant
>
> ps. I've written IOMMU support for four different IOMMUs on three
> operating systems (See drivers/parisc for two linux examples). But I
> still feel like I at best have 80% understanding of how this one is
> organized/works. Abstract descriptions and convoluted code have been
> handicapping me (and lack of time to dig further).

Well, this is one of my concerns with this driver. It isn't easy to read 
(and so review, maintain, extend and debug found issues).

Best regards,
Tomasz
