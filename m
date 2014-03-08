Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaCHXZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 18:25:16 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:51773 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaCHXZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 18:25:13 -0500
Message-ID: <531BA6D3.4030004@gmail.com>
Date: Sun, 09 Mar 2014 00:25:07 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
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
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com> < 20140217181451.7EB7FC4044D@trevor.secretlab.ca> <20140218070624.GP17250@ pengutronix.de> <20140218162627.32BA4C40517@trevor.secretlab.ca> < 1393263389.3091.82.camel@pizza.hi.pengutronix.de> <20140226110114. CF2C7C40A89@trevor.secretlab.ca> <1393426129.3248.64.camel@paszta.hi. pengutronix.de> <20140307170550.1DFB2C40A0D@trevor.secretlab.ca> <531AF1E8. 50606@ti.com> <20140308114115.BB08EC40612@trevor.secretlab.ca>
In-Reply-To: <20140308114115.BB08EC40612@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2014 12:41 PM, Grant Likely wrote:
>>> Another thought. In terms of the pattern, I would add a recommendation
>>> >  >  that there should be a way to identify ports of a particular type. ie.
>>> >  >  If I were using the pattern to implement an patch bay of DSP filters,
>>> >  >  where each input and output, then each target node should have a unique
>>> >  >  identifier property analogous to "interrupt-controller" or
>>> >  >  "gpio-controller". In this fictitious example I would probably choose
>>> >  >  "audiostream-input-port" and "audiostream-output-port" as empty
>>> >  >  properties in the port nodes. (I'm not suggesting a change to the
>>> >  >  existing binding, but making a recommendation to new users).
>> >
>> >  I don't see any harm in that, but I don't right away see what could be
>> >  done with them? Did you have something in mind?
>
> It would help with schema validation and allow ports of the same
> interface to get grouped together.
>
>> >  I guess those could be used to study the graph before the drivers have
>> >  been loaded. After the drivers have been loaded, the drivers should
>> >  somehow register themselves and the ports/endpoints. And as the driver
>> >  knows what kind of ports they are, it can supply this information in the
>> >  runtime data structures.
>> >
>> >  If we do that, would it be better to have two pieces of data:
>> >  input/output/bi-directional, and the port type (say, mipi-dpi, lvds, etc.)?

I'm not sure about the direction information (it also came up when we
originally discussed this binding), but the port type information would
be useful. As it turns out, it is not always possible to describe a data
bus interface type/data transmission protocol with a set of primitive
properties in an endpoint node. Especially in cases when the physical
layer is basically identical, for instance in case of MIPI CSI-2 and
SMIA CCP2, or in future MIPI CSI-3 and MIPI CSI-2.

In general there could likely be more than one supported, if both the
transmitter and the receiver are sufficiently configurable.

Then, to be able to fully describe a data port, perhaps we could
add a property like 'interface-type' or 'bus-type' with values like
"mipi-dbi", mipi-dsi", "mipi-csi2", "smia-ccp2", "hdmi", etc.

> Sure. That's worth considering.
