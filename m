Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaFEJqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:46:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:57838 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaFEJqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:46:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,980,1392192000"; 
   d="scan'208";a="441186874"
Date: Thu, 5 Jun 2014 12:46:42 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Mark Brown <broonie@kernel.org>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi/pxa2xx: change default supported DMA burst size to 1
Message-ID: <20140605094642.GJ5214@lahna.fi.intel.com>
References: <1401990309-12492-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401990309-12492-1-git-send-email-chiau.ee.chew@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 01:45:09AM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> This is to fix the SPI DMA transfer failure for speed less than 1M.
> If using current DMA burst size setting (16), the Rx data bytes are
> invalid due to each data byte is multiplied according to the burst
> size setting.
> 
> Let's said supposedly we shall receive the following 18 bytes of data:
> 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18
> Instead, the data bytes received consist of "16 bytes of '01' +
> 2 bytes of '02'" :
> 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 02 02
> 
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>

Works for me (and individual chips can tune this by passing custom
dma_burst_size if needed).

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
