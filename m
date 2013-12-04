Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab3LDOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:09:57 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46838 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932358Ab3LDOJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:09:55 -0500
Date: Wed, 4 Dec 2013 14:09:51 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alex Elder <alex.elder@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mike Turquette <mturquette@linaro.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] clk: bcm281xx: add initial clock framework support
Message-ID: <20131204140951.GA29200@e106331-lin.cambridge.arm.com>
References: <529EA78E.7060904@linaro.org>
 <529EA80F.3050009@linaro.org>
 <20131204111457.GF16025@e106331-lin.cambridge.arm.com>
 <529F28E3.90905@linaro.org>
 <529F34D3.5080806@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529F34D3.5080806@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 01:57:39PM +0000, Alex Elder wrote:
> On 12/04/2013 07:06 AM, Alex Elder wrote:
> >>> +       name_size = strlen(node->name) + 1;
> >>> >> +       ccu = kzalloc(sizeof(*ccu) + name_size, GFP_KERNEL);
> >>> >> +       if (!ccu) {
> >>> >> +               pr_err("%s: unable to map allocate CCU struct for %s\n",
> >>> >> +                       __func__, node->name);
> >>> >> +               return;
> >>> >> +       }
> >>> >> +       memcpy((char *)ccu->name, node->name, name_size);
> >> > 
> >> > You could simplify this with kstrdup.
> > You are correct, and I will make that change.  I think at
> > one point I needed the length but that doesn't appear to
> > be the case here.
> 
> On second thought, no, you may have missed what was happening here.
> I was avoiding two kmallocs() by setting aside space at the end
> of the structure to hold its name.  It may seem silly, but this
> avoids a possible (well, conceivable) failure case.

Yes, I'd misunderstood. Sorry about that.

> 
> However, based on your earlier question about "what about freeing
> ccu->name?" I am going to use kstrdup() here.  I'd rather the code
> put you at ease than look weird just to avoid an unlikely failure.

I'm happy either way.

Mark.
