Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaBQJ5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:57:06 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:43920 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaBQJ5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:57:02 -0500
MIME-Version: 1.0
In-Reply-To: <1392465619-27614-2-git-send-email-sthokal@xilinx.com>
References: <1392465619-27614-1-git-send-email-sthokal@xilinx.com>
	<1392465619-27614-2-git-send-email-sthokal@xilinx.com>
Date: Mon, 17 Feb 2014 15:27:01 +0530
Message-ID: <CAJe_Zhc_GNNSDWNFuk+cMHEqxfSCJB_ey=Bf+SwJK-nS=u9ceg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] dma: Support multiple interleaved frames with
 non-contiguous memory
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, levex@linux.com, lars@metafoo.de,
        lkml <linux-kernel@vger.kernel.org>, dmaengine@vger.kernel.org,
        andriy.shevchenko@linux.intel.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 February 2014 17:30, Srikanth Thokala <sthokal@xilinx.com> wrote:
> The current implementation of interleaved DMA API support multiple
> frames only when the memory is contiguous by incrementing src_start/
> dst_start members of interleaved template.
>
> But, when the memory is non-contiguous it will restrict slave device
> to not submit multiple frames in a batch.  This patch handles this
> issue by allowing the slave device to send array of interleaved dma
> templates each having a different memory location.
>
How fragmented could be memory in your case? Is it inefficient to
submit separate transfers for each segment/frame?
It will help if you could give a typical example (chunk size and gap
in bytes) of what you worry about.

Thanks,
Jassi
