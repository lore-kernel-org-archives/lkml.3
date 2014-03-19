Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaCSSvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:51:24 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:39319 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaCSSvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:51:20 -0400
Message-ID: <5329E729.4020201@gmail.com>
Date: Wed, 19 Mar 2014 19:51:21 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Grundler <grundler@chromium.org>, Tomasz Figa <t.figa@samsung.com>
CC: Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Prathyush <prathyush.k@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: [PATCH v11 17/27] iommu/exynos: remove calls to Runtime PM API
 functions
References: <20140314140843.ba055f28dd7ed59c46088029@samsung.com> <5322FD14.5090602@samsung.com> <20140318185605.0380c8dfe6559c06183092e5@samsung.com> <532861BE.7020601@samsung.com> <20140319100304.5e26fa43ccdfc29178b058e1@samsung.com> <532997D7.6090608@samsung.com> <CANEJEGuYz28dGT+264CYtG+Tk6htOq=u-t4PWMtsij32X0vJFA@mail.gmail.com> <5329D426.9020706@samsung.com> <CANEJEGtCdMmWXwpoky8USLOBw7jAt1bRw8or-mDK7twxAzhWpA@mail.gmail.com>
In-Reply-To: <CANEJEGtCdMmWXwpoky8USLOBw7jAt1bRw8or-mDK7twxAzhWpA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.03.2014 19:37, Grant Grundler wrote:
> On Wed, Mar 19, 2014 at 10:30 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> ...
>> As I said, AFAIK the trend is to get rid of ordering by initcalls and make
>> sure that drivers can handle missing dependencies properly, even for
>> "services" such as DMA, GPIO, clocks and so on, which after all are provided
>> by normal drivers like other.
>
> Ok - I'm not following the general kernel dev trends. initcall()
> levels are easy to understand and implement. So I would not be in a
> hurry to replace them.
>

Well, initcall level is still a way to satisfy most of dependencies, 
i.e. all client devices with higher initcall levels will probe 
successfully. However the other case needs to be handled as well - in 
this case the IOMMU binding code needs to defer probe of client driver 
if respective IOMMU is not yet available.

>>> ps. I've written IOMMU support for four different IOMMUs on three
>>> operating systems (See drivers/parisc for two linux examples). But I
>>> still feel like I at best have 80% understanding of how this one is
>>> organized/works. Abstract descriptions and convoluted code have been
>>> handicapping me (and lack of time to dig further).
>>
>>
>> Well, this is one of my concerns with this driver. It isn't easy to read
>> (and so review, maintain, extend and debug found issues).
>
> My postscript comment was more to explain why I'm not confident in my
> opinion - not a reason to reject the patch series.  I still consider
> the whole series as a step forward. But I'm not the expert here.

I fully agree with you. Other than the issues mentioned in review, the 
patches are definitely a step forward. I'd even say that all the patches 
that have nothing to do with device tree could be merged in their 
current form and the code refined later. It doesn't mean that patches 
shouldn't be reviewed now and issues spotted reported, even if they 
could be fixed later - this is for the IOMMU subsystem maintainer to decide.

As for patches related to DT support, more care needs to be taken, as 
bindings should be designed with stability in mind, so the refining 
process should happen at review stage.

> Right now, with ~30 patches posted by the exynos iommu (official?)
> maintainer, no one else who has a clue will attempt to fix or clean up
> those kinds of problems.  i.e. it's useful to enable others to fix
> what are essentially unspecified "design pattern" issues.

Agreed.

Best regards,
Tomasz
