Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964914AbaCTW0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:26:41 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:47960 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760129AbaCTW0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:26:36 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <531D5D0E.8000605@ti.com>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> < 1393340304-19005-2-git-send-email-p.zabel@pengutronix.de> <20140226113729. A9D5AC40A89@trevor.secretlab.ca> <1393428297.3248.92.camel@paszta.hi. pengutronix.de> <20140307171804.EF245C40A32@trevor.secretlab.ca> <531AF4ED. 5020608@ti.com> <20140308122321.9D433C40612@trevor.secretlab.ca> <531D5D0E. 8000605@ti.com>
Date: Thu, 20 Mar 2014 22:26:31 +0000
Message-Id: <20140320222631.2F0BBC412EA@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 08:34:54 +0200, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 08/03/14 14:23, Grant Likely wrote:
> 
> >>> That's fine. In that case the driver would specifically require the
> >>> endpoint to be that one node.... although the above looks a little weird
> >>
> >> The driver can't require that. It's up to the board designer to decide
> >> how many endpoints are used. A driver may say that it has a single input
> >> port. But the number of endpoints for that port is up to the use case.
> > 
> > Come now, when you're writing a driver you know if it will ever be
> > possible to have more than one port. If that is the case then the
> > binding should be specifically laid out for that. If there will never be
> > multiple ports and the binding is unambiguous, then, and only then,
> > should the shortcut be used, and only the shortcut should be accepted.
> 
> I was talking about endpoints, not ports. There's no unclarity about the
> number of ports, that comes directly from the hardware for that specific
> component. The number of endpoints, however, come from the board
> hardware. The driver writer cannot know that.

Okay, I understand now.

g.

> > Just to be clear, I have no problem with having the option in the
> > pattern, but the driver needs to be specific about what layout it
> > expects.
> 
> If we forget the shortened endpoint format, I think it can be quite
> specific.
> 
> A device has either one port, in which case it should require the
> 'ports' node to be omitted, or the device has more than one port, in
> which case it should require 'ports' node.
> 
> Note that the original v4l2 binding doc says that 'ports' is always
> optional.

The original v4l2 behaviour doesn't need to change. In fact it should
not change if it will cause real-world breakage.

g.
