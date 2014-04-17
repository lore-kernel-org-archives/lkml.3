Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaDQV4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:56:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42709 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaDQV4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:56:40 -0400
Message-ID: <53504DFF.7090907@ti.com>
Date: Thu, 17 Apr 2014 17:56:15 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <balbi@ti.com>, Nishanth Menon <nm@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Sricharan R <r.sricharan@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 05/19] bus: omap_l3_noc: switch over to relaxed variants
 of readl/writel
References: <1397492726-17203-1-git-send-email-nm@ti.com> <1397767775-10965-1-git-send-email-nm@ti.com> <1397767775-10965-6-git-send-email-nm@ti.com> <20140417215228.GD8504@saruman.home>
In-Reply-To: <20140417215228.GD8504@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2014 05:52 PM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Apr 17, 2014 at 03:49:21PM -0500, Nishanth Menon wrote:
>> Currently we use __raw_readl and writel in this driver, however, there
> 
> __raw_* and *_relaxed variants are the same, just have a look <asm/io.h>
> 
Except the relaxed version can take care of endian conversion if
needed. :-)

> 297 #define readb_relaxed(c) ({ u8  __r = __raw_readb(c); __r; })
> 298 #define readw_relaxed(c) ({ u16 __r = le16_to_cpu((__force __le16) \
> 299                                         __raw_readw(c)); __r; })
> 300 #define readl_relaxed(c) ({ u32 __r = le32_to_cpu((__force __le32) \
> 301                                         __raw_readl(c)); __r; })
> 302 
> 303 #define writeb_relaxed(v,c)     __raw_writeb(v,c)
> 304 #define writew_relaxed(v,c)     __raw_writew((__force u16) cpu_to_le16(v),c)
> 305 #define writel_relaxed(v,c)     __raw_writel((__force u32) cpu_to_le32(v),c)
> 

