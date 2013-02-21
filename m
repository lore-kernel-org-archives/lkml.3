Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3BUPxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:53:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34589 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab3BUPxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:53:42 -0500
Date: Thu, 21 Feb 2013 16:53:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDACv2 01/12] edac: add support for raw error reports
Message-ID: <20130221155337.GG4694@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Edac Mailing List <linux-edac@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1361459782.git.mchehab@redhat.com>
 <30b4b936bf5eb2a47613cd3d5a256e4e9c56e911.1361459782.git.mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <30b4b936bf5eb2a47613cd3d5a256e4e9c56e911.1361459782.git.mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 12:38:59PM -0300, Mauro Carvalho Chehab wrote:
> That allows APEI GHES driver to report errors directly, using
> the EDAC error report API.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/edac/edac_core.h |  17 ++++++++
>  drivers/edac/edac_mc.c   | 109 ++++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 100 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> index 23bb99f..9c5da11 100644
> --- a/drivers/edac/edac_core.h
> +++ b/drivers/edac/edac_core.h
> @@ -453,6 +453,23 @@ extern struct mem_ctl_info *find_mci_by_dev(struct device *dev);
>  extern struct mem_ctl_info *edac_mc_del_mc(struct device *dev);
>  extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
>  				      unsigned long page);
> +
> +void edac_raw_mc_handle_error(const enum hw_event_mc_err_type type,
> +			  struct mem_ctl_info *mci,
> +			  long grain,
> +			  const u16 error_count,
> +			  const int top_layer,
> +			  const int mid_layer,
> +			  const int low_layer,
> +			  const unsigned long page_frame_number,
> +			  const unsigned long offset_in_page,
> +			  const unsigned long syndrome,
> +			  const char *msg,
> +			  const char *location,
> +			  const char *label,
> +			  const char *other_detail,
> +			  const bool enable_per_layer_report);

Why not merge this patch with 10/12?

You're adding edac_raw_mc_handle_error here and rewriting it in 10/12.
This looks like unnecessary churn to me.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
