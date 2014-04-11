Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaDKMYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:24:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45988 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbaDKMYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:24:32 -0400
Message-ID: <5347DEDA.2060008@ti.com>
Date: Fri, 11 Apr 2014 15:23:54 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Sekhar Nori <nsekhar@ti.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>,
        Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH v2 05/14] arm: common: edma: Select event queue 1 as default
 when booted with DT
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com> <1396357575-30585-6-git-send-email-peter.ujfalusi@ti.com> <5347A4FD.1030803@ti.com> <5347ACDE.7040407@ti.com> <5347AE49.5020109@ti.com> <5347B7F8.2000508@ti.com> <20140411094217.GA32284@intel.com> <5347D2CC.4030407@ti.com> <20140411113154.GB32284@intel.com>
In-Reply-To: <20140411113154.GB32284@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 02:31 PM, Vinod Koul wrote:

>> I would say that it is channel based config. I don't see the reason why would
>> one mix different priorities on a configured channel between descriptors.
>>
>>> If not then we can add this in dma_slave_config ?
>>
>> So adding to the struct for example:
>> bool high_priority;
> 
> In designware controller, we can have channel priorties from 0 to 7 which IIRC 7
> being highest. So bool wont work. unsigned int/u8 would be good.

I see. But from a generic code what number should one pass if we want to get
the highest priority? With eDMA3 we essentially have three levels (see later)
so if we receive 7 as priority what shall we do? Just treat as highest? But if
we receive 4, which is somewhere in the middle for designware it is still
means highest for us.

I see this too small step partitioning in common code a bit problematic when
it comes to how to interpret the 'magic numbers'.
Also how all the driver in the system will decide the priority number? I'm
sure they will pick something conveniently average for themselves and I
imagine audio would try to pick something which is bigger than the numbers
others have taken...

> How about your controller, is it binary?

We also have priority from 0 to 7, 0 being the highest priority. We have 3
Transfer Controllers/Event Queues and we can set the priority for the TC/EQ
and assign the given channel to the desired TC/EQ.
So in reality we have 3 priorities to choose from in my view since we only
have 3 TC/EQ in eDMA3 (of AM335x/AM447x) on other SoCs we can have different
number of TC/EQ.

-- 
Péter
