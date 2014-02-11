Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaBKOyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:54:33 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:47404 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaBKOyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:54:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] of: Turn of_match_node into a static inline when CONFIG_OF isn't set
Date: Tue, 11 Feb 2014 15:55:35 +0100
Message-ID: <1596542.hkJp71u3OJ@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140211144108.GB841@joshc.qualcomm.com>
References: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard.com> <20140211144108.GB841@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Tuesday 11 February 2014 08:41:08 Josh Cartwright wrote:
> On Tue, Feb 11, 2014 at 01:36:51PM +0100, Laurent Pinchart wrote:
> > when CONFIG_OF is disabled of_match_node is defined as a macro that
> > evaluates to NULL. This breaks compilation of drivers that dereference
> > the function's return value directly. Fix it by turning the macro into a
> > static inline function that returns NULL.
> 
> Just this past week I did the same thing, but noticed that it breaks the
> following usecase:
> 
> 	#ifdef CONFIG_OF
> 	static const struct of_device_id foobar_matches[] = {
> 		{ .compatible = "foobar,whatsit", },
> 		{ },
> 	};
> 	#endif
> 
> 	static int probeme(struct platform_device *pdev)
> 	{
> 		struct of_device_id *id;
> 
> 		id = of_match_node(foobar_matches, pdev->dev.of_node);
> 		if (id) {
> 			/* ... */
> 		}
> 		return 0;
> 	}
> 
> When !CONFIG_OF and with your change, this will fail to build due to
> foobar_matches being undefined.

Good point. What would you think about

#define of_match_node(_matches, _node)  ((const struct of_device_id *)NULL)

?

-- 
Regards,

Laurent Pinchart

