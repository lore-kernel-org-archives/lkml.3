Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbaGCV6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:58:33 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53530 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756845AbaGCV6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:58:32 -0400
Date: Thu, 3 Jul 2014 22:58:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Clark <robdclark@gmail.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v5 00/11] Add DRM for stih4xx platforms
Message-ID: <20140703215826.GA21739@n2100.arm.linux.org.uk>
References: <1403081488-13114-1-git-send-email-benjamin.gaignard@linaro.org> <CAF6AEGsLbmos9nz-AYv2v0g33BYdAgKYTe8_ihDWEF3GK_=gjQ@mail.gmail.com> <20140703215200.GG32514@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703215200.GG32514@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 10:52:00PM +0100, Russell King - ARM Linux wrote:
> On Thu, Jul 03, 2014 at 05:31:21PM -0400, Rob Clark wrote:
> > >From a brief look, it looks like my comments have been addressed, so I
> > think this is starting to shape up..
> > 
> > Laurent/Thierry/Russell, I don't suppose any of you are likely to have
> > time before 3.17 merge window to give sti one last once-over to see
> > what I missed ;-)
> 
> As this appears to be using the component helpers, it would be good for
> the author to be pre-warned about the change to the API.  I'm going to
> be doing this as a two step thing.

More on this... just found it in the series.

It looks fine, and I expect that the update would be trivial:

- the body of sti_drm_add_components() moves into sti_drm_master_probe()
  and sti_drm_add_components() is removed.
- component_master_add_child() is updated to call component_match_add()
- component_master_add() is updated to call component_master_add_with_match()
  instead.

So I don't think there's any problem here.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
