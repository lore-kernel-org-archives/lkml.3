Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117Ab3FFOzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:55:09 -0400
Received: from 20.mo5.mail-out.ovh.net ([91.121.55.239]:40604 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750731Ab3FFOzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:55:07 -0400
Date: Thu, 6 Jun 2013 16:50:59 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, "gnurou@gmail.org" <gnurou@gmail.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH] simplefb: add support for a8b8g8r8 pixel format
Message-ID: <20130606145059.GU19468@game.jcrosoft.org>
References: <1370503259-16618-1-git-send-email-acourbot@nvidia.com>
 <3356BC4D-EEF6-4FCA-9310-5B0727EBF288@jcrosoft.com>
 <51B0446A.4090305@nvidia.com>
 <29610936-BB03-4844-888B-56E1C8E5DF4A@jcrosoft.com>
 <51B047FD.4020400@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B047FD.4020400@nvidia.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11729062279561718760
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

On 17:27 Thu 06 Jun     , Alex Courbot wrote:
> On 06/06/2013 05:24 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >
> >On Jun 6, 2013, at 10:12 AM, Alex Courbot <acourbot@nvidia.com> wrote:
> >
> >>On 06/06/2013 04:59 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >>>
> >>>On Jun 6, 2013, at 9:20 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> >>>
> >>>>Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> >>>>---
> >>>>Documentation/devicetree/bindings/video/simple-framebuffer.txt | 1 +
> >>>>drivers/video/simplefb.c                                       | 1 +
> >>>>2 files changed, 2 insertions(+)
> >>>>
> >>>>diff --git a/Documentation/devicetree/bindings/video/simple-framebuffer.txt b/Documentation/devicetree/bindings/video/simple-framebuffer.txt
> >>>>index 3ea4605..70c26f3 100644
> >>>>--- a/Documentation/devicetree/bindings/video/simple-framebuffer.txt
> >>>>+++ b/Documentation/devicetree/bindings/video/simple-framebuffer.txt
> >>>>@@ -12,6 +12,7 @@ Required properties:
> >>>>- stride: The number of bytes in each line of the framebuffer.
> >>>>- format: The format of the framebuffer surface. Valid values are:
> >>>>   - r5g6b5 (16-bit pixels, d[15:11]=r, d[10:5]=g, d[4:0]=b).
> >>>>+  - a8b8g8r8 (32-bit pixels, d[31:24]=a, d[23:16]=b, d[15:8]=g, d[7:0]=r).
> >>>>
> >>>>Example:
> >>>>
> >>>>diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
> >>>>index e2e9e3e..d7041aa 100644
> >>>>--- a/drivers/video/simplefb.c
> >>>>+++ b/drivers/video/simplefb.c
> >>>>@@ -84,6 +84,7 @@ struct simplefb_format {
> >>>>
> >>>>static struct simplefb_format simplefb_formats[] = {
> >>>>	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
> >>>>+	{ "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {31, 8} },
> >>>
> >>>why don't you parse the string?
> >>>
> >>>so you will a real generic bindings
> >>
> >>Tried that already, got NACKed: https://lkml.org/lkml/2013/5/27/330
> >>
> >>The list of modes of this driver should not grow too big. Even in terms of footprint I'd say the list should remain smaller than the parsing code.
> >>
> >>What we can discuss though is whether we want to keep this a8b8g8r8 syntax or switch to something more standard, say "rgba8888".
> >
> >I'm going to be very honest I do not like the simplefb driver from the beginning
> >but I do found it useful. And as said in it's name it need to be *SIMPLE*
> >
> >Then a huge list of compatible no way
> >otherwise we drop this from the simplefb and make it a generic helper
> >
> >I do not want to see format parser in every drivers this need to handle at video framework level
> >
> >If I see that we start to increase again and again the simplefb I will not accept
> >to merge the code as we must keep it simple
> 
> In that case it's probably better to maintain a "simple" list of
> supported modes, which is what this patch does.

so get out it of the simplefb other drivers can use it

Best Regards,
J.
> Alex.
> 
