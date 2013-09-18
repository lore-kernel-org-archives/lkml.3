Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3IRXCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 19:02:49 -0400
Received: from smtprelay0067.hostedemail.com ([216.40.44.67]:34314 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751533Ab3IRXCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 19:02:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:421:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352
X-HE-Tag: rock40_34d6f0b336f2d
X-Filterd-Recvd-Size: 2103
Message-ID: <1379545361.1787.87.camel@joe-AO722>
Subject: Re: [PATCH v2] clk: si570: Add a driver for SI570 oscillators
From: Joe Perches <joe@perches.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hyun Kwon <hyunk@xilinx.com>
Date: Wed, 18 Sep 2013 16:02:41 -0700
In-Reply-To: <1379544219-23579-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1379544219-23579-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 15:43 -0700, Soren Brinkmann wrote:
> Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
> The devices generate low-jitter clock signals and are reprogrammable via
> an I2C interface.
[]
> v2:
[]
>  - use 10000 as MIN and MAX value in usleep_range
[]
> diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
[]
> +static int si570_set_frequency(struct clk_si570 *data, unsigned long frequency)
> +{
[]
> +	/* Applying a new frequency can take up to 10ms */
> +	usleep_range(10000, 10000);

Generally it's nicer to have an actual range for usleep_range.

Is there a bit you could periodically poll to see
if the new frequency has been set or is stable so
that a 10ms delay isn't always used?


