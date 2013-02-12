Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160Ab3BLLLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 06:11:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51676 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758734Ab3BLLLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 06:11:48 -0500
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>
Subject: RE: [PATCH V2] Regulator: Reorder the min max assignment in the
 sequence of regulator_set_voltage function
Thread-Topic: [PATCH V2] Regulator: Reorder the min max assignment in the
 sequence of regulator_set_voltage function
Thread-Index: AQHOCCSeeDJo8q2CGUu0t11Gm6LTiph0h3uAgAGLAtA=
Date: Tue, 12 Feb 2013 11:11:41 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229B9912@DBDE01.ent.ti.com>
References: <1360565374-1553-1-git-send-email-j-keerthy@ti.com>
 <20130211170525.GK4607@opensource.wolfsonmicro.com>
In-Reply-To: <20130211170525.GK4607@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Monday, February 11, 2013 10:35 PM
> To: J, KEERTHY
> Cc: linux-kernel@vger.kernel.org; lgirdwood@gmail.com
> Subject: Re: [PATCH V2] Regulator: Reorder the min max assignment in
> the sequence of regulator_set_voltage function
> 
> On Mon, Feb 11, 2013 at 12:19:34PM +0530, J Keerthy wrote:
> 
> > The min and max values for regulators are getting assigned before
> > actually the voltage is set. So making sure that min and max values
> > are assigned only if the voltage is successfully set else keeping the
> > last successfully set voltage's min and max values.
> 
> > This is boot tested on OMAP4430 and OMAP4460 boards.
> 
> This seems fine but doesn't apply against topic/core or -next, can you
> please regenerate against topic/core and resend?

I pulled the topic/core on to my tree. Seems like the exact fix has
Already been made in that branch :-P.

commit 92d7a55879c01b30349045501108e775655a4b92
Author: Paolo Pisati <paolo.pisati@canonical.com>
Date:   Thu Dec 13 10:13:00 2012 +0100

    regulator: core: if voltage scaling fails, restore original voltage values

It is already taken care. 
> 
> > V2: Fixed comment from Mark. Introduced local variables to hold
> > current min and max values.
> 
> Don't include things like this in the changelog, include them after the
> --- as covered in SubmittingPatches.

Ok

Thanks,
Keerthy
