Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3BMStQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:49:16 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:41219 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab3BMStN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:49:13 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <20130213184559.GA29145@quad.lixom.net>
References: <1360778532-7480-1-git-send-email-dianders@chromium.org>
	<20130213184559.GA29145@quad.lixom.net>
Date: Wed, 13 Feb 2013 10:49:11 -0800
Message-ID: <CAOesGMjjwiAB2PVDvK-ci05rqYbmrgMUDDZ8GWAetsVhDCQwpQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] i2c: mux: Add i2c-arbitrator 'mux' driver
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        Prashanth G <prashanth.g@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Stephen Warren <swarren@nvidia.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 10:45 AM, Olof Johansson <olof@lixom.net> wrote:

>> +             i2c-parent = <&{/i2c@12CA0000}>;
>
> Why use this custom i2c-parent property? The arbitrator should just be
> under the i2c controller in the device tree, and thus parent would be
> derived from the topology there.

Ah. Reading up on the discussions for the other mux bindings, there's
the issue of the arbitrator not being addressable/accessible via i2c.

Sigh, awkward and annoying, since it breaks the topography for the
hardware apart due to the arbitrator. But I guess there's no good
alternative. :(


-Olof
