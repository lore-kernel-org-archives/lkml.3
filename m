Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaKITZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 14:25:40 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:17314 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaKITZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 14:25:38 -0500
Date: Sun, 9 Nov 2014 20:28:20 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] of: Make const the device node pointers in
 of_clk_get and of_node_put
Message-ID: <20141109202820.026252bf@armhf>
In-Reply-To: <20141109185019.GU4042@n2100.arm.linux.org.uk>
References: <cover.1415557680.git.moinejf@free.fr>
	<375a82230accf26dfbbb74e6f928243ea8e38b50.1415557680.git.moinejf@free.fr>
	<20141109185019.GU4042@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2014 18:50:19 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> What this then means is that it fundamentally undermines the idea of
> storing the pointer to a device_node as a const pointer, as the device
> node must always be modified when you're done with it (because it's a
> ref-counted structure.)  So, having it const in your code is a bug.
> 
> What this also means is that every other place that you've added const
> below is also very dubious.

Thanks for the explanation.

The correct patch will be simpler: in the ASoC structures, I found only
three places where the device_node pointer is const.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
