Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3J3Ufj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:35:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3J3Ufh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:35:37 -0400
Date: Wed, 30 Oct 2013 16:35:17 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Doug Thompson <dougthompson@xmission.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 01/12] sb_edac: move PCI IDs to pci_ids.h
Message-ID: <20131030203516.GE16166@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
 <1383150426-24730-2-git-send-email-arozansk@redhat.com>
 <20131030164020.GF13290@pd.tnic>
 <20131030151936.48ba7af5@samsung.com>
 <CAErSpo5rhsDqmROLRhagbQP=6Ydfun9ZD0PFP0FO_08j0FQ4vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5rhsDqmROLRhagbQP=6Ydfun9ZD0PFP0FO_08j0FQ4vQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 11:21:49AM -0600, Bjorn Helgaas wrote:
> On Wed, Oct 30, 2013 at 11:19 AM, Mauro Carvalho Chehab
> <m.chehab@samsung.com> wrote:
> > Em Wed, 30 Oct 2013 17:40:20 +0100
> > Borislav Petkov <bp@alien8.de> escreveu:
> >
> >> On Wed, Oct 30, 2013 at 12:26:55PM -0400, Aristeu Rozanski wrote:
> >> > According to the comment, it should be done before submitting upstream.
> >> >
> >> > Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
> >> > ---
> >> >  drivers/edac/sb_edac.c  |   21 ++-------------------
> >> >  include/linux/pci_ids.h |   11 +++++++++++
> >> >  2 files changed, 13 insertions(+), 19 deletions(-)
> >> >
> >> > diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
> >> > index e04462b..4cdd948 100644
> >> > --- a/drivers/edac/sb_edac.c
> >> > +++ b/drivers/edac/sb_edac.c
> >> > @@ -57,26 +57,9 @@ static int probed;
> >> >   */
> >> >
> >> >  /*
> >> > - * FIXME: For now, let's order by device function, as it makes
> >> > - * easier for driver's development process. This table should be
> >> > - * moved to pci_id.h when submitted upstream
> >>
> >> Why, is anything else besides sb_edac.c using those?
> >>
> > I think that this patch makes sense, as the other Sandy Bridge registers
> > are at pci_ids.h. So, it is a matter of consistency.
> >
> > Also, I won't doubt that other drivers could need to access those, as
> > there are other things there on a few of those PCI IDs.
> >
> > Yet, on patch 12/12, you're adding the Ivy Bridge specific PCI IDs
> > inside the driver.
> >
> > So, IMHO, you should either move all to pci_ids.h or to keep them inside
> > the driver.
> >
> > My personal taste would be to move them all to pci_ids.h.
> 
> As long as it follows the guideline at the top of pci_ids.h (add them
> there only if they are shared between multiple drivers), I'm fine with
> putting them in pci_ids.h.

Fair enough, I think we can drop the first patch. I checked and all the
patches apply without the first one and it builds fine. Mauro, want me
to resubmit the patchset anyway?

-- 
Aristeu

