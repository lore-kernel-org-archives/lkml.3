Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3FFQYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:24:17 -0400
Received: from 10.mo5.mail-out.ovh.net ([46.105.52.148]:38480 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751115Ab3FFQYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:24:16 -0400
Date: Thu, 6 Jun 2013 18:20:11 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alex Courbot <acourbot@nvidia.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Olof Johansson <olof@lixom.net>, "gnurou@gmail.org" <gnurou@gmail.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH] simplefb: add support for a8b8g8r8 pixel format
Message-ID: <20130606162011.GV19468@game.jcrosoft.org>
References: <1370503259-16618-1-git-send-email-acourbot@nvidia.com>
 <3356BC4D-EEF6-4FCA-9310-5B0727EBF288@jcrosoft.com>
 <51B0446A.4090305@nvidia.com>
 <51B0B4A2.4010104@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B0B4A2.4010104@wwwdotorg.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13235516355212258125
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:11 Thu 06 Jun     , Stephen Warren wrote:
> On 06/06/2013 02:12 AM, Alex Courbot wrote:
> > On 06/06/2013 04:59 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >>
> >> On Jun 6, 2013, at 9:20 AM, Alexandre Courbot <acourbot@nvidia.com>
> >> wrote:
> >>
> >>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> No commit description? It'd be useful to at least justify this by
> mentioning that some platform will actually use this...
> 
> ...
> >>> static struct simplefb_format simplefb_formats[] = {
> >>>     { "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
> >>> +    { "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {31, 8} },
> >>
> >> why don't you parse the string?
> >>
> >> so you will a real generic bindings
> > 
> > Tried that already, got NACKed: https://lkml.org/lkml/2013/5/27/330
> > 
> > The list of modes of this driver should not grow too big. Even in terms
> > of footprint I'd say the list should remain smaller than the parsing code.
> > 
> > What we can discuss though is whether we want to keep this a8b8g8r8
> > syntax or switch to something more standard, say "rgba8888".
> 
> I would prefer to keep the syntax of the new formats consistent, so that
> if we ever do add format-parsing code rather than table-based lookup,
> all the existing formats will continue to work unchanged, without any
> kind of fallback lookup table.

I do prefer a format-parsing than any long lookup table that take time at boot
time

Best Regards,
J.
