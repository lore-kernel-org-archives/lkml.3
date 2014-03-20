Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbaCTRXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:23:12 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:61675 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127AbaCTRXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:23:07 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <1883687.VdfitvQEN3@avalon>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < 139468148.3QhLg3QYq1@avalon> <531F08A8.300@ti.com> <1883687.VdfitvQEN3@ avalon>
Date: Thu, 20 Mar 2014 17:23:02 +0000
Message-Id: <20140320172302.CD320C4067A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 14:16:37 +0100, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> On Tuesday 11 March 2014 14:59:20 Tomi Valkeinen wrote:
> > So depending on the use case, the endpoints would point to opposite
> > direction from the encoder's point of view.
> > 
> > And if I gathered Grant's opinion correctly (correct me if I'm wrong),
> > he thinks things should be explicit, i.e. the bindings for, say, an
> > encoder should state that the encoder's output endpoint _must_ contain a
> > remote-endpoint property, whereas the encoder's input endpoint _must
> > not_ contain a remote-endpoint property.
> 
> Actually my understand was that DT links would have the same direction as the 
> data flow. There would be no ambiguity in that case as the direction of the 
> data flow is known. What happens for bidirectional data flows still need to be 
> discussed though. And if we want to use the of-graph bindings to describe 
> graphs without a data flow, a decision will need to be taken there too.

On further thinking, I would say linkage direction should be in the
direction that would be considered the dependency order... I'm going to
soften my position though. I think the generic pattern should still
recommend unidirection links in direction of device dependency, but
I'm okay with allowing the bidirection option if the helper functions
are modified to validate the target endpoint. I think it needs to test
for the following:
- Make sure the endpoint either:
  - does not have a backlink, or
  - the backlink points back to the origin node
- If the target is an endpoint node, then make sure the parent doesn't
  have a link of any kind
- If the target is a port node, make sure it doesn't have any endpoint
  children nodes at all.

g.


