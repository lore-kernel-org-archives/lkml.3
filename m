Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaCKNol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:44:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36305 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbaCKNoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:44:38 -0400
Message-ID: <1394545463.3772.24.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>,
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
Date: Tue, 11 Mar 2014 14:44:23 +0100
In-Reply-To: <531F0F4F.3070008@ti.com>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
	 <139468148.3QhLg3QYq1@avalon> <531F08A8.300@ti.com>
	 <1883687.VdfitvQEN3@avalon> <531F0F4F.3070008@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Dienstag, den 11.03.2014, 15:27 +0200 schrieb Tomi Valkeinen:
> On 11/03/14 15:16, Laurent Pinchart wrote:
> 
> >> And if I gathered Grant's opinion correctly (correct me if I'm wrong),
> >> he thinks things should be explicit, i.e. the bindings for, say, an
> >> encoder should state that the encoder's output endpoint _must_ contain a
> >> remote-endpoint property, whereas the encoder's input endpoint _must
> >> not_ contain a remote-endpoint property.
> > 
> > Actually my understand was that DT links would have the same direction as the 
> > data flow. There would be no ambiguity in that case as the direction of the 
> 
> Ok. At least at some point in the discussion the rule of thumb was to
> have the "master" point at the "slave", which are a bit vague terms, but
> I think both display and camera controllers were given as examples of
> "master".
> 
> > data flow is known. What happens for bidirectional data flows still need to be 
> > discussed though. And if we want to use the of-graph bindings to describe 
> > graphs without a data flow, a decision will need to be taken there too.
> 
> Yep. My worry is that if the link direction is defined in the bindings
> for the device, somebody will at some point have a complex board which
> happens to use two devices in such a way, that either neither of them
> point to each other, or both point to each other.
> 
> Maybe we can make sure that never happens, but I feel a bit nervous
> about it especially for bi-directional cases. If the link has no clear
> main-dataflow direction, it may be a bit difficult to say which way to link.
> 
> With double-linking all those concerns just disappear.

another possibility would be to just leave it open in the generic
bindings:

"Two endpoints are considered linked together if any of them contains a
 'remote-endpoint' phandle property that points to the other. If both
 contain a 'remote-endpoint' property, both must point at each other."

As long as we make sure that the generic code is able to generate the
undirected graph from this, we could then let more specific bindings
(like video-interfaces.txt) define that the phandle links always should
point in both directions, in data flow direction, north, or outwards
from the 'master'.

regards
Philipp

