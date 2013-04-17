Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966431Ab3DQScG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:32:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33328 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966029Ab3DQScF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:32:05 -0400
Message-ID: <516EEAA0.10906@wwwdotorg.org>
Date: Wed, 17 Apr 2013 12:32:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
In-Reply-To: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 09:45 AM, Christian Ruppert wrote:
> The pinmux driver of the Abilis Systems TB10x platform based on ARC700 CPUs.
> Used to control the pinmux and is a prerequisite for the GPIO driver.

Linus already did a review of this, but I have a few extra comments:

> diff --git a/Documentation/devicetree/bindings/pinctrl/abilis,tb10x-iomux.txt b/Documentation/devicetree/bindings/pinctrl/abilis,tb10x-iomux.txt

> +Abilis Systems TB10x pin controller
> +===================================
> +
> +Required properties
> +-------------------
> +
> +- #address-cells: should be <1>.
> +- #size-cells: should be <1>;

What are those two used for? They would normally only be required if the
child nodes of the pinctrl node contained "reg" properties. But, they
don't in the examples later in this file.

> +Ports are defined (and referenced) by sub-nodes of the pin controller. Every
> +sub-node defines exactly one port (i.e. a set of pins). Ports are defined by
> +their names in the pin controller driver.

I'm not really sure what the implication here is. Does this mean that
the driver isn't expected to contain tables which define which
pins/groups/functions exist, but rather gets those lists/tables from the
DT? I prefer not to do that, although it is acceptable to write the
binding/driver this way.


So there seems to be something huge missing here; the only property
defined here for the child nodes is "pingrp". In the examples, there's
nothing else used. I don't see how this binding allows the actual
desired mux functions to be specified. All other pinctrl DT bindings
have the child nodes contain something along the lines of:

* A list of pins/groups to apply the settings to.
* A property defining the mux function to select on those pins/groups.
* Other properties defining configuration for those pins/groups, such as
pull-up/down, drive-type, drive-strength, etc.

All that seems missing here. Surely it's required?

Perhaps this "abilis,simple-default" thing is intended to represent some
specific default configuration? If so, I don't think that's the right
way to go. Also, the DT binding should be as complete as possible from
the start, rather than planning to define/implement part of it now and
then keep adding to it later. This all implies that some extra
properties really should be defined here.

