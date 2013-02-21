Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3BUQBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:01:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab3BUQBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:01:42 -0500
Date: Thu, 21 Feb 2013 13:01:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDACv2 01/12] edac: add support for raw error reports
Message-ID: <20130221130125.7f649d4c@redhat.com>
In-Reply-To: <20130221155337.GG4694@pd.tnic>
References: <cover.1361459782.git.mchehab@redhat.com>
	<30b4b936bf5eb2a47613cd3d5a256e4e9c56e911.1361459782.git.mchehab@redhat.com>
	<20130221155337.GG4694@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 21 Feb 2013 16:53:37 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Thu, Feb 21, 2013 at 12:38:59PM -0300, Mauro Carvalho Chehab wrote:
> > That allows APEI GHES driver to report errors directly, using
> > the EDAC error report API.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > ---
> >  drivers/edac/edac_core.h |  17 ++++++++
> >  drivers/edac/edac_mc.c   | 109 ++++++++++++++++++++++++++++++++++++-----------
> >  2 files changed, 100 insertions(+), 26 deletions(-)
> > 
> > diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> > index 23bb99f..9c5da11 100644
> > --- a/drivers/edac/edac_core.h
> > +++ b/drivers/edac/edac_core.h
> > @@ -453,6 +453,23 @@ extern struct mem_ctl_info *find_mci_by_dev(struct device *dev);
> >  extern struct mem_ctl_info *edac_mc_del_mc(struct device *dev);
> >  extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
> >  				      unsigned long page);
> > +
> > +void edac_raw_mc_handle_error(const enum hw_event_mc_err_type type,
> > +			  struct mem_ctl_info *mci,
> > +			  long grain,
> > +			  const u16 error_count,
> > +			  const int top_layer,
> > +			  const int mid_layer,
> > +			  const int low_layer,
> > +			  const unsigned long page_frame_number,
> > +			  const unsigned long offset_in_page,
> > +			  const unsigned long syndrome,
> > +			  const char *msg,
> > +			  const char *location,
> > +			  const char *label,
> > +			  const char *other_detail,
> > +			  const bool enable_per_layer_report);
> 
> Why not merge this patch with 10/12?
> 
> You're adding edac_raw_mc_handle_error here and rewriting it in 10/12.
> This looks like unnecessary churn to me.

I did this way to to follow the "one patch per logical change rule".
The rationale for this patch is to allow doing raw error reports,
as needed by changeset 06/12.

The rationale for 10/12 was to reduce the stack pressure. While
10/12 touches on the above routine, it's main focus is to fix a
previous fixup of using a large space inside the stack during the
memory report preparation.

Regards,
Mauro
