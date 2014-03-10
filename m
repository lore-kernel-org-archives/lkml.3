Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaCJOlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:41:09 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:33211 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaCJOlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:41:07 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <531D916C.2010903@ti.com>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com> < 20140217181451.7EB7FC4044D@trevor.secretlab.ca> <20140218070624.GP17250@ pengutronix.de> <20140218162627.32BA4C40517@trevor.secretlab.ca> < 1393263389.3091.82.camel@pizza.hi.pengutronix.de> <20140226110114. CF2C7C40A89@trevor.secretlab.ca> <1393426129.3248.64.camel@paszta.hi. pengutronix.de> <20140307170550.1DFB2C40A0D@trevor.secretlab.ca> <531AF1E8. 50606@ti.com> <20140308114115.BB08EC40612@trevor.secretlab.ca> <531D916C. 2010903@ti.com>
Date: Mon, 10 Mar 2014 14:41:02 +0000
Message-Id: <20140310144102.58C13C405FA@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 12:18:20 +0200, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 08/03/14 13:41, Grant Likely wrote:
> 
> >> Ok. If we go for single directional link, the question is then: which
> >> way? And is the direction different for display and camera, which are
> >> kind of reflections of each other?
> > 
> > In general I would recommend choosing whichever device you would
> > sensibly think of as a master. In the camera case I would choose the
> > camera controller node instead of the camera itself, and in the display
> > case I would choose the display controller instead of the panel. The
> > binding author needs to choose what she things makes the most sense, but
> > drivers can still use if it it turns out to be 'backwards'
> 
> I would perhaps choose the same approach, but at the same time I think
> it's all but clear. The display controller doesn't control the panel any
> more than a DMA controller controls, say, the display controller.

In a sense it doesn't actually matter. You sensibly want to choose the
most likely direction that drivers would go looking for a device it
depends on, but it can be matched up at runtime regardless of the
direction chosen by the binding.

g.
