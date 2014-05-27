Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaE0PDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:03:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59897 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbaE0PDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:03:50 -0400
Message-ID: <5384A92B.4080606@ti.com>
Date: Tue, 27 May 2014 10:03:07 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Olof Johansson <olof@lixom.net>
CC: Dan Williams <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, Sekhar Nori <nsekhar@ti.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v3 01/10] platform_data: edma: Be precise with the paRAM
 struct
References: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>	<1397475725-5036-2-git-send-email-peter.ujfalusi@ti.com> <CAOesGMg43jT6D_ot2tKfRXXgAgwqs5Pu_tAFKc35yxLAczrzGQ@mail.gmail.com> <53846779.4070204@ti.com>
In-Reply-To: <53846779.4070204@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 05:22 AM, Peter Ujfalusi wrote:
> On 05/27/2014 12:32 AM, Olof Johansson wrote:
[..]
>>
>> I came across this patch when I was looking at a pull request from
>> Sekhar for EDMA cleanups, and it made me look closer at the contents
>> of this file.
>>
>> The include/linux/platform_data/ directory is meant to hold
>> platform_data definitions for drivers, and nothing more.
>> platform_data/edma.h also contains a whole bunch of interface
>> definitions for the driver. They do not belong there, and should be
>> moved to a different include file.
>>
>> That also includes the above struct, because as far as I can tell it's
>> a runtime state structure, not something that is passed in with
>> platform data.
>>
>> Can someone please clean this up? Thanks.
> 
> I think Joel is working on to move/merge the code from arch/arm/common/edma.c
> to drivers/dma/edma.c

Yes, I am planning to work on that soon. But there is an issue, more on
that discussed below..

> I'm sure within this work he is going to clean up the header file as well.

Agreed. The private API should not be expored in any header and should
be exclusive for the EDMA dmaengine driver ideally.

> As a first step I think the non platform_data content can be moved as
> include/linux/edma.h or probably as ti-edma.h?
> 

sound/soc/davinci/davinci-pcm.c: This still uses the EDMA private API in
arch/arm/common/edma.c. Peter, any idea when the private usage will be
removed fully, and we switch to dmaengine for ASoC? Before that can
happen, we can't clean up or do any merges.

What I'd like to do is fold the private API into the dmaengine driver
and eliminate the need to expose the private API, thus also getting rid
of the interface declarations Olof referred to.

thanks,

-Joel

