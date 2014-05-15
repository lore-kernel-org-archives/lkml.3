Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaEOJhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:37:04 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:56852 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbaEOJg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:36:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Thu, 15 May 2014 11:36:33 +0200
From: Stefan Agner <stefan@agner.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, swarren@wwwdotorg.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, marcel@ziswiler.com
Subject: Re: [PATCH v2 2/3] drm/panel: add support for EDT panels
In-Reply-To: <20140515090814.GB6434@ulmo>
References: <cover.1400103181.git.stefan@agner.ch>
 <35c081171a3d9a9401767601c02a12e266b37dd0.1400103181.git.stefan@agner.ch>
 <20140515075102.GE5952@ulmo>
 <1400142449.4102.16.camel@paszta.hi.pengutronix.de>
 <20140515090814.GB6434@ulmo>
Message-ID: <90bb509e9aa9c705790e2e0574d77b9f@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-05-15 11:08, schrieb Thierry Reding:
> On Thu, May 15, 2014 at 10:27:29AM +0200, Philipp Zabel wrote:
>> The ETM0700G0DH6 Datasheet lists 2 lines as the typical vsync pulse
>> width, 525 lines as the vertical period, and 35 lines as the vsync -de
>> time, which is vsync len + back porch.
>> So vertical timings 480 + 10 + 2 + 33 = 525 should be valid for the
>> ET0700G0DH6 panel:
> 
> Shouldn't that work with 480 + 8 + 2 + 35 too? It seems to me that it
> should still be safe for that panel. Similarily I'd expect your timings
> to work on the ET070080DH6.

Am 2014-05-15 11:12, schrieb Thierry Reding:
> Okay, so that means that the panel works for you with the same timings
> that Philipp has in the ETM0700G0DH6 patch? If so then I definitely
> think we should be sharing the timings in the driver by making the two
> compatible entries point to the same driver data.

FWIW, I checked and it works with both timings. And I bet it is really
the same panel its just a different touch on top.

> Irrespective of that they both seem to have different capabilities so
> two compatible values should be fine. However for the purpose of the
> simple panel driver they could be made to share the same timings if it
> works for both panels and devices.
> 
> As for the touch panel on the ETM0700G0DH6, do you happen to know how
> that's usually connected? I suspect it needs external hardware to
> capture the YU, XL, YD and XR pins and turn that into raw coordinates
> and pen down interrupts.

For Colibri Evaluation Board, those pins are routed to the generic
4-wire pins of the Colibri SO-DIMM. On the Colibri T30 module, those
pins are connected to a STMPE811. I also added that to the device tree
once, however it does not work properly atm, I need to debug this and
will send a patch at a later time.

--
Stefan

