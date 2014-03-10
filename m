Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaCJN5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:57:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37071 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaCJN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:57:48 -0400
Message-ID: <1394459844.7380.33.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v6 2/8] Documentation: of: Document graph bindings
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Mon, 10 Mar 2014 14:57:24 +0100
In-Reply-To: <2406124.RniJY1n1Xd@avalon>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
	 <20140307182717.67596C40B43@trevor.secretlab.ca>
	 <1394443690.7380.10.camel@paszta.hi.pengutronix.de>
	 <2406124.RniJY1n1Xd@avalon>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 10.03.2014, 12:37 +0100 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> On Monday 10 March 2014 10:28:10 Philipp Zabel wrote:
> > Hi Grant,
> > 
> > Am Freitag, den 07.03.2014, 18:27 +0000 schrieb Grant Likely:
> > > On Wed,  5 Mar 2014 10:20:36 +0100, Philipp Zabel wrote:
> > > > The device tree graph bindings as used by V4L2 and documented in
> > > > Documentation/device-tree/bindings/media/video-interfaces.txt contain
> > > > generic parts that are not media specific but could be useful for any
> > > > subsystem with data flow between multiple devices. This document
> > > > describes the generic bindings.
> > > > 
> > > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > 
> > > See my comments on the previous version. My concerns are the handling of
> > > the optional 'ports' node and the usage of reverse links.
> > 
> > would this change address your concern about the reverse links? As the
> > preexisting video-interfaces.txt bindings mandate the reverse links, I
> > worry about introducing a second, subtly different binding. It should be
> > noted somewhere in video-interfaces.txt that the reverse links are
> > deprecated for the but still supported by the code for backwards
> > compatibility.
> 
> I'm very much against removing the reverse links. Without them the graph will 
> become much more complex to parse. You can try to convince me, but for now I'm 
> afraid it's a NACK.

For the record, I'd prefer to keep them, too. Besides the parsing
complexity, it just feels more natural to take both ends and connect
them together. If phandles are only permitted to point in one direction,
there's always the additional question which direction is the right one.

Assume, for example, the following setup of two SoC digital audio
interfaces connected to an audio codec and a bluetooth chip,
respectively. The audio codec has a second audio interface that is
connected directly to the bluetooth chip for headset operation:

,-------.     ,--------.
| dai1 [0]---[0] codec |
`-------'  ,-[1]       |
           |  `--------'
           |  ,-----.
,-------.  `-[1] bt |
| dai2 [0]---[0]    |
`-------'     `-----´

How to decide which direction the codec:1 <-->  bt:1 link should point
in?

regards
Philipp

