Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaBKOn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:43:28 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37844 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaBKOn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:43:26 -0500
Date: Tue, 11 Feb 2014 08:41:08 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] of: Turn of_match_node into a static inline when
 CONFIG_OF isn't set
Message-ID: <20140211144108.GB841@joshc.qualcomm.com>
References: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Laurent-

On Tue, Feb 11, 2014 at 01:36:51PM +0100, Laurent Pinchart wrote:
> when CONFIG_OF is disabled of_match_node is defined as a macro that
> evaluates to NULL. This breaks compilation of drivers that dereference
> the function's return value directly. Fix it by turning the macro into a
> static inline function that returns NULL.

Just this past week I did the same thing, but noticed that it breaks the
following usecase:

	#ifdef CONFIG_OF
	static const struct of_device_id foobar_matches[] = {
		{ .compatible = "foobar,whatsit", },
		{ },
	};
	#endif
	
	static int probeme(struct platform_device *pdev)
	{
		struct of_device_id *id;
	
		id = of_match_node(foobar_matches, pdev->dev.of_node);
		if (id) {
			/* ... */
		}
		return 0;
	}

When !CONFIG_OF and with your change, this will fail to build due to
foobar_matches being undefined.

   Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
