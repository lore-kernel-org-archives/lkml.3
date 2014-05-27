Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaE0KXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 06:23:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50980 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaE0KXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 06:23:17 -0400
Message-ID: <53846779.4070204@ti.com>
Date: Tue, 27 May 2014 13:22:49 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Dan Williams <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, Sekhar Nori <nsekhar@ti.com>,
        Joel Fernandes <joelf@ti.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v3 01/10] platform_data: edma: Be precise with the paRAM
 struct
References: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>	<1397475725-5036-2-git-send-email-peter.ujfalusi@ti.com> <CAOesGMg43jT6D_ot2tKfRXXgAgwqs5Pu_tAFKc35yxLAczrzGQ@mail.gmail.com>
In-Reply-To: <CAOesGMg43jT6D_ot2tKfRXXgAgwqs5Pu_tAFKc35yxLAczrzGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 12:32 AM, Olof Johansson wrote:
> Hi,
> 
> On Mon, Apr 14, 2014 at 4:41 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>> The edmacc_param struct should follow the layout of the paRAM area in the
>> HW. Be explicit on the size of the fields (u32) and also mark the struct
>> as packed to avoid any padding on non 32bit architectures.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> Acked-by: Joel Fernandes <joelf@ti.com>
>> ---
>>  include/linux/platform_data/edma.h | 18 +++++++++---------
>>  1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
>> index f50821cb64be..923f8a3e4ce0 100644
>> --- a/include/linux/platform_data/edma.h
>> +++ b/include/linux/platform_data/edma.h
>> @@ -43,15 +43,15 @@
>>
>>  /* PaRAM slots are laid out like this */
>>  struct edmacc_param {
>> -       unsigned int opt;
>> -       unsigned int src;
>> -       unsigned int a_b_cnt;
>> -       unsigned int dst;
>> -       unsigned int src_dst_bidx;
>> -       unsigned int link_bcntrld;
>> -       unsigned int src_dst_cidx;
>> -       unsigned int ccnt;
>> -};
>> +       u32 opt;
>> +       u32 src;
>> +       u32 a_b_cnt;
>> +       u32 dst;
>> +       u32 src_dst_bidx;
>> +       u32 link_bcntrld;
>> +       u32 src_dst_cidx;
>> +       u32 ccnt;
>> +} __packed;
>>
>>  /* fields in edmacc_param.opt */
>>  #define SAM            BIT(0)
> 
> I came across this patch when I was looking at a pull request from
> Sekhar for EDMA cleanups, and it made me look closer at the contents
> of this file.
> 
> The include/linux/platform_data/ directory is meant to hold
> platform_data definitions for drivers, and nothing more.
> platform_data/edma.h also contains a whole bunch of interface
> definitions for the driver. They do not belong there, and should be
> moved to a different include file.
> 
> That also includes the above struct, because as far as I can tell it's
> a runtime state structure, not something that is passed in with
> platform data.
> 
> Can someone please clean this up? Thanks.

I think Joel is working on to move/merge the code from arch/arm/common/edma.c
to drivers/dma/edma.c
I'm sure within this work he is going to clean up the header file as well.
As a first step I think the non platform_data content can be moved as
include/linux/edma.h or probably as ti-edma.h?

-- 
Péter
