Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbbANVi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:38:59 -0500
Received: from axentia.se ([87.96.186.132]:8806 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbbANVi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:38:57 -0500
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2015 16:38:57 EST
From: Peter Rosin <peda@axentia.se>
To: Nicolas Ferre <nicolas.ferre@atmel.com>, Peter Rosin <peda@lysator.liu.se>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Yang, Wenyou" <Wenyou.Yang@atmel.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: RE: [PATCH RESEND] pm: at91: Workaround DDRSDRC self-refresh bug
 with LPDDR1 memories
Thread-Topic: [PATCH RESEND] pm: at91: Workaround DDRSDRC self-refresh bug
 with LPDDR1 memories
Thread-Index: AQHQL/z0UdFqcVIZE02JmVeEThh+dZy/wt+AgABZRZA=
Date: Wed, 14 Jan 2015 21:33:21 +0000
Message-ID: <018060d2585f4e5480b1bdd39a56e70c@EMAIL.axentia.se>
References: <1421241632-2991-1-git-send-email-peda@lysator.liu.se>
 <54B69DAB.8010303@atmel.com>
In-Reply-To: <54B69DAB.8010303@atmel.com>
Accept-Language: en-US, sv-SE
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.210.101.82]
x-gfi-smtp-submission: 1
x-gfi-smtp-hellodomain: EMAIL.axentia.se
x-gfi-smtp-remoteip: 192.168.2.5
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> Le 14/01/2015 14:20, Peter Rosin a écrit :
> > From: Peter Rosin <peda@axentia.se>
> >
> > The DDRSDR controller (on the ATSAMA5D31) fails miserably to put
> > LPDDR1 memories in self-refresh. Force the controller to think it has
> > DDR2 memories during the self-refresh period, as the DDR2 self-refresh
> > spec is equivalent to LPDDR1, and is correctly implemented in the
> controller.
> >
> > Assume that the second controller has the same fault, and that other
> > CPUs in the family has the same problem, but that is untested.
> >
> > Signed-off-by: Peter Rosin <peda@axentia.se>
> 
> I've just verified your code and the scope of this issue and your
> implementation makes perfect sense.
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Peter,
> Thanks for your patch. You will probably see it appearing in 3.20 or 3.21.

Great!

> Wenyou,
> Can you please integrate the patch from Peter in your current rework of the
> PM routines (keeping his authorship of course)?
> Please tell me if I can help with this.

To be 100% honest with credits, I should perhaps have mentioned that I
received an unconditional proof-of-concept patch from Atmel support
(Case 00007347). I'm not certain who wrote that patch, but the only thing
that has survived is the idea to temporarily use DDR2 mode and the trivial
change of the register field width in the header file. So, I do not feel too
dishonest by claiming authorship...

Cheers,
Peter

