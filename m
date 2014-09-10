Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaIJG7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:59:10 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:64435 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaIJG7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:59:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140909155716.GN1610@intel.com>
References: <1406549869-24422-1-git-send-email-sthokal@xilinx.com>
	<1406549869-24422-2-git-send-email-sthokal@xilinx.com>
	<20140819170346.GS13288@intel.com>
	<CA+mB=1L14Os=ZdJzj8_+XXa+oq4ZOS_kadQHpKQ2yws2tqGVSQ@mail.gmail.com>
	<20140904063613.GD1610@intel.com>
	<CA+mB=1KarJGUYTZu=2k46gqt3oMAuYawfq+H=Lxa7YVqcThjCw@mail.gmail.com>
	<20140909155716.GN1610@intel.com>
Date: Wed, 10 Sep 2014 12:29:05 +0530
X-Google-Sender-Auth: Tr0Z1DOxUlgimWX4cF6eQHPD2mY
Message-ID: <CA+mB=1+1EgDDrnmn1dKjU6Q__1uxgRcCrHx1-ho9+AWkSvCThA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] dma: Add Xilinx AXI Direct Memory Access Engine
 driver support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Levente Kurusa <levex@linux.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, anirudh@xilinx.com, svemula@xilinx.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Tue, Sep 9, 2014 at 9:27 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Tue, Sep 09, 2014 at 12:52:16AM +0530, Srikanth Thokala wrote:
>> Hi Vinod,
>>
>> On Thu, Sep 4, 2014 at 12:06 PM, Vinod Koul <vinod.koul@intel.com> wrote:
>> > On Wed, Sep 03, 2014 at 12:17:43PM +0530, Srikanth Thokala wrote:
>> >> Hi Vinod,
>> >>
>> >> Apologies for the delay.
>> >>
>> >> On Tue, Aug 19, 2014 at 10:33 PM, Vinod Koul <vinod.koul@intel.com> wrote:
>> >> > On Mon, Jul 28, 2014 at 05:47:49PM +0530, Srikanth Thokala wrote:
>> >> >> +struct xilinx_dma_chan {
>> >> >> +     struct xilinx_dma_device *xdev;
>> >> >> +     u32 ctrl_offset;
>> >> >> +     spinlock_t lock;
>> >> >> +     struct list_head pending_list;
>> >> >> +     struct xilinx_dma_tx_descriptor *active_desc;
>> >> >> +     struct xilinx_dma_tx_descriptor *allocated_desc;
>> >> >> +     struct list_head done_list;
>> >> >> +     struct list_head free_seg_list;
>> >> >> +     struct dma_chan common;
>> >> >> +     struct xilinx_dma_tx_segment *seg_v;
>> >> >> +     dma_addr_t seg_p;
>> >> >> +     struct device *dev;
>> >> >> +     int irq;
>> >> >> +     int id;
>> >> >> +     enum dma_transfer_direction direction;
>> >> > This looks suspect. Why should channel have direction, for a descriptor it
>> >> > makes sense though.
>> >>
>> >> The channel only supports transfers in one direction. Either from memory to
>> >> peripheral or from peripheral to memory, that's fixed and can't be changed
>> >> at runtime.  So, the driver needs to know which direction the channel supports
>> >> and hence it can reject transfers with the wrong direction.
>> > But you already have this information in descriptor so why duplicate?
>>
>> Our descriptor doesn't have the information of channel direction, we have this
>> information only in the chan structure (struct xilinx_dma_chan) which
>> is populated
>> while parsing the DT.  So, we use this information to ensure if we are servicing
>> proper channel (in prep_slave_sg call).
> One of the argument of prep_slave_sg call is direction. You need to use that
> and store in in your descriptor for using it afterwards
>
>> FYI: We also need the direction of the channel so that we can select SRC/DST
>> register address in the issue_pending() call.
> And you have the descriptor there as well so can use it

Ok, got it. Thanks.  I will send v4 with the changes mentioned.

- Srikanth

>
> --
> ~Vinod
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
