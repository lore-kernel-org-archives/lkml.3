Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaGKTW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:22:56 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:38607 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaGKTWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:22:54 -0400
Date: Fri, 11 Jul 2014 15:22:49 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: "Bridgman, John" <John.Bridgman@amd.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>, David Airlie <airlied@linux.ie>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, "Gabbay, Oded" <Oded.Gabbay@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>,
        Kenneth Heitke <kheitke@codeaurora.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for AMD's
 GPUs
Message-ID: <20140711192248.GP1870@gmail.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-8-git-send-email-oded.gabbay@amd.com>
 <20140711170411.GJ1870@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01031B37@storexdag02.amd.com>
 <20140711181053.GK1870@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01031C4E@storexdag02.amd.com>
 <20140711185138.GN1870@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01031CAD@storexdag02.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D89D60253BB73A4E8C62F9FD18A939CA01031CAD@storexdag02.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:56:12PM +0000, Bridgman, John wrote:
> >From: Jerome Glisse [mailto:j.glisse@gmail.com]
> >Sent: Friday, July 11, 2014 2:52 PM
> >To: Bridgman, John
> >Cc: Oded Gabbay; David Airlie; Deucher, Alexander; linux-
> >kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; Lewycky, Andrew;
> >Joerg Roedel; Gabbay, Oded; Greg Kroah-Hartman; Rafael J. Wysocki; Kishon
> >Vijay Abraham I; Sandeep Nair; Kenneth Heitke; Srinivas Pandruvada;
> >Santosh Shilimkar; Andreas Noever; Lucas Stach; Philipp Zabel
> >Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for
> >AMD's GPUs
> >
> >On Fri, Jul 11, 2014 at 06:46:30PM +0000, Bridgman, John wrote:
> >> >From: Jerome Glisse [mailto:j.glisse@gmail.com]
> >> >Sent: Friday, July 11, 2014 2:11 PM
> >> >To: Bridgman, John
> >> >Cc: Oded Gabbay; David Airlie; Deucher, Alexander; linux-
> >> >kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; Lewycky,
> >> >Andrew; Joerg Roedel; Gabbay, Oded; Greg Kroah-Hartman; Rafael J.
> >> >Wysocki; Kishon Vijay Abraham I; Sandeep Nair; Kenneth Heitke;
> >> >Srinivas Pandruvada; Santosh Shilimkar; Andreas Noever; Lucas Stach;
> >> >Philipp Zabel
> >> >Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver
> >> >for AMD's GPUs
> >> >
> >> >On Fri, Jul 11, 2014 at 06:02:39PM +0000, Bridgman, John wrote:
> >> >> >From: Jerome Glisse [mailto:j.glisse@gmail.com]
> >> >> >Sent: Friday, July 11, 2014 1:04 PM
> >> >> >To: Oded Gabbay
> >> >> >Cc: David Airlie; Deucher, Alexander;
> >> >> >linux-kernel@vger.kernel.org;
> >> >> >dri- devel@lists.freedesktop.org; Bridgman, John; Lewycky, Andrew;
> >> >> >Joerg Roedel; Gabbay, Oded; Greg Kroah-Hartman; Rafael J. Wysocki;
> >> >> >Kishon Vijay Abraham I; Sandeep Nair; Kenneth Heitke; Srinivas
> >> >> >Pandruvada; Santosh Shilimkar; Andreas Noever; Lucas Stach;
> >> >> >Philipp Zabel
> >> >> >Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver
> >> >> >for AMD's GPUs
> >> >> >
> >> >> >On Fri, Jul 11, 2014 at 12:50:09AM +0300, Oded Gabbay wrote:
> >> >> >> This patch adds the code base of the hsa driver for AMD's GPUs.
> >> >> >>
> >> >> >> This driver is called kfd.
> >> >> >>
> >> >> >> This initial version supports the first HSA chip, Kaveri.
> >> >> >>
> >> >> >> This driver is located in a new directory structure under drivers/gpu.
> >> >> >>
> >> >> >> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> >> >> >
> >> >> >There is too coding style issues. While we have been lax on the
> >> >> >enforcing the scripts/checkpatch.pl rules i think there is a limit
> >> >> >to that. I am not strict on the 80chars per line but others things
> >> >> >needs fixing
> >> >so we stay inline.
> >> >> >
> >> >> >Also i am a bit worried about the license, given top comment in
> >> >> >each of the files i am not sure this is GPL2 compatible. I would
> >> >> >need to ask lawyer to review that.
> >> >> >
> >> >>
> >> >> Hi Jerome,
> >> >>
> >> >> Which line in the license are you concerned about ? In theory we're
> >> >> using
> >> >the same license as the initial code pushes for radeon, and I just
> >> >did a side-by side compare with the license header on cik.c in the
> >> >radeon tree and confirmed that the two licenses are identical.
> >> >>
> >> >> The cik.c header has an additional "Authors:" line which the kfd
> >> >> files do
> >> >not, but AFAIK that is not part of the license text proper.
> >> >>
> >> >
> >> >You can not claim GPL if you want to use this license. radeon is
> >> >weird best for historical reasons as we wanted to share code with BSD
> >> >thus it is dual licensed and this is reflected with :
> >> >MODULE_LICENSE("GPL and additional rights");
> >> >
> >> >inside radeon_drv.c
> >> >
> >> >So if you want to have MODULE_LICENSE(GPL) then you should have
> >> >header that use the GPL license wording and no wording from BSD like
> >license.
> >> >Otherwise change the MODULE_LICENSE and it would also be good to say
> >> >dual licensed at top of each files (or least next to each license) so
> >> >that it is clear this is BSD & GPL license.
> >>
> >> Got it. Missed that we had a different MODULE_LICENSE.
> >>
> >> Since the goal is license compatibility with radeon so we can update the
> >interface and move code between the drivers in future I guess my
> >preference would be to update MODULE_LICENSE in the kfd code to "GPL and
> >additional rights", do you think that would be OK ?
> >
> >I am not a lawyer and nothing that i said should be considered as legal advice
> >(on the contrary ;)) I think you need to be more clear with each license to
> >clear says GPLv2 or BSD ie dual licensed but the dual license is a beast you
> >would definitly want to talk to lawyer about.
> 
> Yeah, dual license seems horrid in its implications for developers so we've always tried to avoid it. GPL hurts us for porting to other OSes so the X11 / "GPL with additional rights" combo seemed like the ideal solution and we made it somewhat of a corporate standard. Hope that doesn't come back to haunt us. 
> 
> Meditate on this I will. Thanks !

Just to be explicit, my point is that is you claim GPL in MODULE_LICENSE
then this is a GPL licensed code, if you claim GPL with additional rights
than this is dual licensed code. This is how i read and interpret this
with additional rights. In all the case the radeon code is considered
dual license ie GPL+BSD (at least this is how i consider that code).

Cheers,
Jérôme
