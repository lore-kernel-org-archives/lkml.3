Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3GUXgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 19:36:39 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38579 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3GUXgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 19:36:38 -0400
MIME-Version: 1.0
In-Reply-To: <51EC4859.5000007@gmail.com>
References: <1373013818-11365-1-git-send-email-b32955@freescale.com>
 <20130709070541.GQ516@pengutronix.de> <51DBBFDA.70302@freescale.com>
 <20130709075124.GR516@pengutronix.de> <51DBC58D.90002@freescale.com>
 <20130720054439.308B33E13F0@localhost> <51EC4859.5000007@gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 22 Jul 2013 00:36:17 +0100
X-Google-Sender-Auth: fn066vAYlLQBaxvGSqxDyQE90b0
Message-ID: <CACxGe6s2UjFkZBOUKVP5=4kW9a=vKT3kQA8YrtitPgC4PLj6jw@mail.gmail.com>
Subject: Re: [PATCH] of: match the compatible in the order set by the dts file
To: Rob Herring <robherring2@gmail.com>
Cc: Huang Shijie <b32955@freescale.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 9:45 PM, Rob Herring <robherring2@gmail.com> wrote:
> We can debate whether the driver order matters or not, but either way
> I'm not sure this patch does the right thing. It doesn't really look
> correct to me, but I haven't dug into it.
>
> We've already tried to fix matching and reverted the fix once before
> (commit below). So this patch needs careful review and thought about
> cases where the name and/or type is used to match.

The rules have always been well established. This patch /shouldn't/
cause any regression that cannot be narrowed down to a fixable driver
bug.

A harder problem to solve however is dealing with the case when
multiple drivers will potentially bind against the same device. Making
that work requires getting all of the match tables into the kernel
early so that the kernel can select the correct driver of many. Can't
be that big a problem though since we've never actually tried to solve
it.  :-)

[...]
>     Rob Herring explains:
>      "The problem is match combinations of compatible plus name and/or type
>       fail to match correctly.  I have a fix for this, but given how late it
>       is for 3.5 I think it is best to revert this for now.  There could be
>       other cases that rely on the current although wrong behavior.  I will
>       post an updated version for 3.6."

I don't believe the fix ever got posted. Do you still have it? Or can
you describe what needs to be done?

g.
