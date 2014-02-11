Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaBKSLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:11:05 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:34177 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBKSLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:11:03 -0500
Date: Tue, 11 Feb 2014 12:08:46 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] of: Turn of_match_node into a static inline when
 CONFIG_OF isn't set
Message-ID: <20140211180845.GG841@joshc.qualcomm.com>
References: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1596542.hkJp71u3OJ@avalon>
 <20140211164825.GC841@joshc.qualcomm.com>
 <6446980.WMjvBYStRY@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6446980.WMjvBYStRY@avalon>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 06:20:49PM +0100, Laurent Pinchart wrote:
> On Tuesday 11 February 2014 10:48:26 Josh Cartwright wrote:
> > On Tue, Feb 11, 2014 at 03:55:35PM +0100, Laurent Pinchart wrote:
> > > On Tuesday 11 February 2014 08:41:08 Josh Cartwright wrote:
> > > > On Tue, Feb 11, 2014 at 01:36:51PM +0100, Laurent Pinchart wrote:
[..]
> > I am a bit weary about having an of_match_node() user that both directly
> > dereferences the result (i.e. of_match_node(matches, np)->data) _and_
> > builds when !CONFIG_OF; most likely due to a traumatic childhood event
> > where demons flew out my nose.
>
> I can assign the intermediate value to a variable before dereferencing it and
> drop my of_match_node() patch if it makes everybody happier.

Assuming you also intend to handle the case of_match_node() may return
NULL, or otherwise prevent the execution of this codepath when
!CONFIG_OF, then, yes, that sounds good.

It sure would be convenient if platform_device had a 'const struct
of_device_id *of_id_entry' member similar to the existing struct
platform_device_id one, that was set up during platform device matching.
Most platform_driver users of of_match_node() would simply go away.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
