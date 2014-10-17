Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaJQN2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:28:18 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45448 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaJQN2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:28:16 -0400
Date: Fri, 17 Oct 2014 14:28:02 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yifan Zhang <yifan.zhangm@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "ganapatrao.kulkarni@caviumnetworks.com" 
	<ganapatrao.kulkarni@caviumnetworks.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>,
        "Yalin.Wang@sonymobile.com" <Yalin.Wang@sonymobile.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yifan Zhang <zhangyf@marvell.com>
Subject: Re: [PATCH v2] arm64: mm: use macro instead of if judgement of
 ZONE_DMA
Message-ID: <20141017132801.GH10873@e104818-lin.cambridge.arm.com>
References: <CAGZxSSSBpCvJt=PFbihTmPneJqiocU8VZSDHpXgkf5dhWZ850Q@mail.gmail.com>
 <20141016171012.GE5252@e104818-lin.cambridge.arm.com>
 <CAGZxSSSZ+b28rcHYRi5EWV9K4izHZBkO3fJTdang5XTaNMRTrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGZxSSSZ+b28rcHYRi5EWV9K4izHZBkO3fJTdang5XTaNMRTrw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 04:08:43AM +0100, Yifan Zhang wrote:
> I found In current arm64 code, there is no normal zone, only DMA zone.
> 
> Number of blocks type     Unmovable  Reclaimable      Movable
> Reserve          CMA      Isolate
> 
> Node 0, zone    DMA          142           12           69
> 1           28            0
> 
> When zone_sizes_init, zone_size[ZONE_NORMAL] is initialized to 0. (it
> is 3.10, I didn't try the latest code base)
[...]
> Is this ZONE_DMA cover full memory and ZONE_NORMAL = 0 strategy on
> purpose ? We will not use ZONE_NORMAL on arm64 ?

The normal zone is still there, only that it doesn't have any pages. The
page allocator falls back to the DMA zone, so you would not see any
problems with normal page allocation.

Are you trying to solve anything (performance?) or just what the kernel
shows as part of the normal zone?

-- 
Catalin
