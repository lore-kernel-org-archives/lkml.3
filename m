Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaBQSUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:20:00 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50350 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaBQST6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:19:58 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: Turn of_match_node into a static inline when CONFIG_OF isn't set
To: Josh Cartwright <joshc@codeaurora.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
In-Reply-To: <20140211164825.GC841@joshc.qualcomm.com>
References: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard .com> <20140211144108.GB841@joshc.qualcomm.com> <1596542.hkJp71u3OJ@avalon> <20140211164825.GC841@joshc.qualcomm.com>
Date: Mon, 17 Feb 2014 18:19:53 +0000
Message-Id: <20140217181953.297FBC40372@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 10:48:26 -0600, Josh Cartwright <joshc@codeaurora.org> wrote:
> On Tue, Feb 11, 2014 at 03:55:35PM +0100, Laurent Pinchart wrote:
> > Hi Josh,
> > 
> > On Tuesday 11 February 2014 08:41:08 Josh Cartwright wrote:
> > > On Tue, Feb 11, 2014 at 01:36:51PM +0100, Laurent Pinchart wrote:
> > > > when CONFIG_OF is disabled of_match_node is defined as a macro that
> > > > evaluates to NULL. This breaks compilation of drivers that dereference
> > > > the function's return value directly. Fix it by turning the macro into a
> > > > static inline function that returns NULL.
> > > 
> > > Just this past week I did the same thing, but noticed that it breaks the
> > > following usecase:
> > > 
> > > 	#ifdef CONFIG_OF
> > > 	static const struct of_device_id foobar_matches[] = {
> > > 		{ .compatible = "foobar,whatsit", },
> > > 		{ },
> > > 	};
> > > 	#endif
> > > 
> > > 	static int probeme(struct platform_device *pdev)
> > > 	{
> > > 		struct of_device_id *id;
> > > 
> > > 		id = of_match_node(foobar_matches, pdev->dev.of_node);
> > > 		if (id) {
> > > 			/* ... */
> > > 		}
> > > 		return 0;
> > > 	}
> > > 
> > > When !CONFIG_OF and with your change, this will fail to build due to
> > > foobar_matches being undefined.
> > 
> > Good point. What would you think about
> > 
> > #define of_match_node(_matches, _node)  ((const struct of_device_id *)NULL)
> 
> I've just sent out a patchset that cleans up at least a couple of users
> that directly do of_match_node(matches, np)->data using
> of_find_matching_node_and_match.  Not sure if that will fix the usage
> you have in mind, though.
> 
> I am a bit weary about having an of_match_node() user that both directly
> dereferences the result (i.e. of_match_node(matches, np)->data) _and_
> builds when !CONFIG_OF; most likely due to a traumatic childhood event
> where demons flew out my nose.

As is supposed to happen when code dereferrences pointers blindly.

g.

