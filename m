Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3CEIod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:44:33 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:42728 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3CEIoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:44:32 -0500
Date: Tue, 5 Mar 2013 16:44:53 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        dan.magenheimer@oracle.com
Subject: Re: [PATCH 11/11] zcache/zbud: Add incremental accessory counters
Message-ID: <20130305084453.GA861@kroah.com>
References: <1362421101-15896-1-git-send-email-konrad.wilk@oracle.com>
 <1362421101-15896-12-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362421101-15896-12-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 01:18:21PM -0500, Konrad Rzeszutek Wilk wrote:
> that are going to be used for debug fs entries.

what debugfs entries?

> 
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/staging/zcache/zbud.c | 58 +++++++++++++++++++++++++++++--------------
>  1 file changed, 39 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zbud.c b/drivers/staging/zcache/zbud.c
> index fdff5c6..0feb856 100644
> --- a/drivers/staging/zcache/zbud.c
> +++ b/drivers/staging/zcache/zbud.c
> @@ -301,6 +301,26 @@ static ssize_t zbud_eph_unbuddied_count;
>  static ssize_t zbud_pers_unbuddied_count;
>  static ssize_t zbud_eph_zombie_count;
>  static ssize_t zbud_pers_zombie_count;
> +static inline void inc_zbud_eph_pageframes(void) { zbud_eph_pageframes++; };
> +static inline void inc_zbud_pers_pageframes(void) { zbud_pers_pageframes++; };
> +static inline void inc_zbud_eph_zpages(void) { zbud_eph_zpages++; };

<snip>

That's just insane, why are you doing this?

As you aren't using this yet, I'm not going to apply this patch, sorry.

greg k-h
