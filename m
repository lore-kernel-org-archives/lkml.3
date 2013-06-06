Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3FFQdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:33:52 -0400
Received: from 13.mo5.mail-out.ovh.net ([87.98.182.191]:32843 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752881Ab3FFQdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:33:50 -0400
Date: Thu, 6 Jun 2013 18:29:43 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alex Courbot <acourbot@nvidia.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Olof Johansson <olof@lixom.net>, "gnurou@gmail.org" <gnurou@gmail.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH] simplefb: add support for a8b8g8r8 pixel format
Message-ID: <20130606162943.GX19468@game.jcrosoft.org>
References: <1370503259-16618-1-git-send-email-acourbot@nvidia.com>
 <3356BC4D-EEF6-4FCA-9310-5B0727EBF288@jcrosoft.com>
 <51B0446A.4090305@nvidia.com>
 <29610936-BB03-4844-888B-56E1C8E5DF4A@jcrosoft.com>
 <51B047FD.4020400@nvidia.com>
 <20130606145059.GU19468@game.jcrosoft.org>
 <51B0B61C.2000008@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B0B61C.2000008@wwwdotorg.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13396520042798295885
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:17 Thu 06 Jun     , Stephen Warren wrote:
> On 06/06/2013 08:50 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 17:27 Thu 06 Jun     , Alex Courbot wrote:
> >> On 06/06/2013 05:24 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >>>
> >>> On Jun 6, 2013, at 10:12 AM, Alex Courbot <acourbot@nvidia.com> wrote:
> >>>
> >>>> On 06/06/2013 04:59 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >>>>>
> >>>>> On Jun 6, 2013, at 9:20 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> ...
> >>>>>> static struct simplefb_format simplefb_formats[] = {
> >>>>>> 	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
> >>>>>> +	{ "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {31, 8} },
> >>>>>
> >>>>> why don't you parse the string?
> 
> Jean-Christophe, I'm afraid I can't tell exactly what you're arguing for.
> 
> Here, you want code added to parse the string ...
> 
> This has already been rejected as being over-engineered, and more than
> this simple driver needs. Even if it were shared code, the only
> practical use of such a parsing function would be to support this
> driver, since presumably any other HW-specific driver already knows
> exactly which format the FB is in, and hence wouldn't need to share this
> code.
> 
> >>>>> so you will a real generic bindings
> >>>>
> >>>> Tried that already, got NACKed: https://lkml.org/lkml/2013/5/27/330
> >>>>
> >>>> The list of modes of this driver should not grow too big. Even in terms of footprint I'd say the list should remain smaller than the parsing code.
> >>>>
> >>>> What we can discuss though is whether we want to keep this a8b8g8r8 syntax or switch to something more standard, say "rgba8888".
> >>>
> >>> I'm going to be very honest I do not like the simplefb driver from the beginning
> >>> but I do found it useful. And as said in it's name it need to be *SIMPLE*
> >>>
> >>> Then a huge list of compatible no way
> >>> otherwise we drop this from the simplefb and make it a generic helper
> >>>
> >>> I do not want to see format parser in every drivers this need to handle at video framework level
> 
> ... yet here you appear to be arguing against using a format parser, or
> including a format parser ...
> 
> Note that a lookup table isn't any kind of shared parser; it's just a
> very tiny and simple table of static data. It seems quite unlikely that
> this could be a maintenance issue, even if over time a few more entries
> get added to the table.
> 
> >>> If I see that we start to increase again and again the simplefb I will not accept
> >>> to merge the code as we must keep it simple
> >>
> >> In that case it's probably better to maintain a "simple" list of
> >> supported modes, which is what this patch does.
> > 
> > so get out it of the simplefb other drivers can use it
> 
> ... yet here you appear to want to move the list of modes into some
> central location ...
> 
> I don't think that's useful for the reason I mentioned above: presumably
> any other HW-specific driver already knows exactly which format the FB
> is in, and hence wouldn't need to share this code/table.
> 
> Why don't we simply take this patch to extend this table, and then *if*
> any other FB driver needs to parse a format from DT, we can move the
> code(table) to a common location at that time. That will be a trivial
> change, and one this patch does nothing to make any harder. Making the
> code/table common before then seems like over-engineering.

that why I said *if I see that we start ....*

I did reject this patch but put a warning I do not want to see a huge table
if so => factorisation or parser

Best Regards,
J.
