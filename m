Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbbAURbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:31:52 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:44192 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbbAURbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:31:40 -0500
Date: Wed, 21 Jan 2015 17:31:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        t.stanislaws@samsung.com, linaro-kernel@lists.linaro.org,
        robdclark@gmail.com, daniel@ffwll.ch, m.szyprowski@samsung.com
Subject: Re: [RFCv2 2/2] dma-buf: add helpers for sharing attacher
 constraints with dma-parms
Message-ID: <20150121173128.GV26493@n2100.arm.linux.org.uk>
References: <1421813807-9178-1-git-send-email-sumit.semwal@linaro.org>
 <1421813807-9178-3-git-send-email-sumit.semwal@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421813807-9178-3-git-send-email-sumit.semwal@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 09:46:47AM +0530, Sumit Semwal wrote:
> +static int calc_constraints(struct device *dev,
> +			    struct dma_buf_constraints *calc_cons)
> +{
> +	struct dma_buf_constraints cons = *calc_cons;
> +
> +	cons.dma_mask &= dma_get_mask(dev);

I don't think this makes much sense when you consider that the DMA
infrastructure supports buses with offsets.  The DMA mask is th
upper limit of the _bus_ specific address, it is not a mask per-se.

What this means is that &= is not the right operation.  Moreover,
simply comparing masks which could be from devices on unrelated
buses doesn't make sense either.

However, that said, I don't have an answer for what you want to
achieve here.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
