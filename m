Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaFVNPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 09:15:19 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38296 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751659AbaFVNPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 09:15:14 -0400
Date: Sun, 22 Jun 2014 14:14:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 1/4] crypto: Add Allwinner Security System crypto
	accelerator
Message-ID: <20140622131452.GF32514@n2100.arm.linux.org.uk>
References: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com> <1402404197-4236-2-git-send-email-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402404197-4236-2-git-send-email-clabbe.montjoie@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 02:43:14PM +0200, LABBE Corentin wrote:
> +int sunxi_aes_poll(struct ablkcipher_request *areq)
> +{
...
> +	if (areq->src == NULL || areq->dst == NULL) {
> +		dev_err(ss->dev, "ERROR: Some SGs are NULL %u\n", areq->nbytes);
> +		return -1;

You return -1 from here quite frequently.  Have you verified that there
is no way for this return value to get to userspace?

Even if it can't get to userspace now, what if someone modifies the code
so it can be returned?

I detest crap that's written with "return -1" in it because it looks like
there is no care with the established error handling semantics for the
kernel (small negative numbers are errno codes.)

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
