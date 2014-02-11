Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaBKTRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:17:16 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:48939 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaBKTQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:16:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] of: Turn of_match_node into a static inline when CONFIG_OF isn't set
Date: Tue, 11 Feb 2014 20:17:59 +0100
Message-ID: <2194247.ngWdBSP92t@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140211180845.GG841@joshc.qualcomm.com>
References: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard.com> <6446980.WMjvBYStRY@avalon> <20140211180845.GG841@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Tuesday 11 February 2014 12:08:46 Josh Cartwright wrote:
> On Tue, Feb 11, 2014 at 06:20:49PM +0100, Laurent Pinchart wrote:
> > On Tuesday 11 February 2014 10:48:26 Josh Cartwright wrote:
> > > On Tue, Feb 11, 2014 at 03:55:35PM +0100, Laurent Pinchart wrote:
> > > > On Tuesday 11 February 2014 08:41:08 Josh Cartwright wrote:
> > > > > On Tue, Feb 11, 2014 at 01:36:51PM +0100, Laurent Pinchart wrote:
> [..]
> 
> > > I am a bit weary about having an of_match_node() user that both directly
> > > dereferences the result (i.e. of_match_node(matches, np)->data) _and_
> > > builds when !CONFIG_OF; most likely due to a traumatic childhood event
> > > where demons flew out my nose.
> > 
> > I can assign the intermediate value to a variable before dereferencing it
> > and drop my of_match_node() patch if it makes everybody happier.
> 
> Assuming you also intend to handle the case of_match_node() may return
> NULL, or otherwise prevent the execution of this codepath when
> !CONFIG_OF, then, yes, that sounds good.

I'll condition the call of that function to IS_ENABLED(CONFIG_OF), yes.

> It sure would be convenient if platform_device had a 'const struct
> of_device_id *of_id_entry' member similar to the existing struct
> platform_device_id one, that was set up during platform device matching.
> Most platform_driver users of of_match_node() would simply go away.

There's definitely room for improvement (although in this particular case the 
driver handles an I2C device, not a platform device).

I've always been slightly bothered by the duplication of matching information 
between native/legacy device IDs and OF device IDs. I haven't really given 
this a thought though, but I believe something should be done.

I've just remembered that, in the I2C case, the I2C core selects the 
appropriate i2c_device_id matching entry based on the compatible string, 
provided that the i2c_device_id table matches the of_device_id table with I2C 
device names set to the OF compatible string with the vendor prefix stripped 
off. Just food for thought.

-- 
Regards,

Laurent Pinchart

