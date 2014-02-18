Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbaBRL2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 06:28:08 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:61406 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbaBRL2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 06:28:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAJe_Zhc_GNNSDWNFuk+cMHEqxfSCJB_ey=Bf+SwJK-nS=u9ceg@mail.gmail.com>
References: <1392465619-27614-1-git-send-email-sthokal@xilinx.com>
	<1392465619-27614-2-git-send-email-sthokal@xilinx.com>
	<CAJe_Zhc_GNNSDWNFuk+cMHEqxfSCJB_ey=Bf+SwJK-nS=u9ceg@mail.gmail.com>
Date: Tue, 18 Feb 2014 16:58:04 +0530
X-Google-Sender-Auth: AX7TBZ1b1M2ER1xpu6k0C4SEkME
Message-ID: <CA+mB=1KdZZpTmpA0Xp_c4mhgFbjRZ6urYrCwdvoTCmcugQMDUA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] dma: Support multiple interleaved frames with
 non-contiguous memory
From: Srikanth Thokala <sthokal@xilinx.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, michal.simek@xilinx.com,
        Grant Likely <grant.likely@linaro.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, Levente Kurusa <levex@linux.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        lkml <linux-kernel@vger.kernel.org>, dmaengine@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 3:27 PM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> On 15 February 2014 17:30, Srikanth Thokala <sthokal@xilinx.com> wrote:
>> The current implementation of interleaved DMA API support multiple
>> frames only when the memory is contiguous by incrementing src_start/
>> dst_start members of interleaved template.
>>
>> But, when the memory is non-contiguous it will restrict slave device
>> to not submit multiple frames in a batch.  This patch handles this
>> issue by allowing the slave device to send array of interleaved dma
>> templates each having a different memory location.
>>
> How fragmented could be memory in your case? Is it inefficient to
> submit separate transfers for each segment/frame?
> It will help if you could give a typical example (chunk size and gap
> in bytes) of what you worry about.

With scatter-gather engine feature in the hardware, submitting separate
transfers for each frame look inefficient. As an example, our DMA engine
supports up to 16 video frames, with each frame (a typical video frame
size) being contiguous in memory but frames are scattered into different
locations. We could not definitely submit frame by frame as it would be
software overhead (HW interrupting for each frame) resulting in video lags.

By this approach, it will allow slave device to submit multiple frames at
once.

Srikanth

>
> Thanks,
> Jassi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
