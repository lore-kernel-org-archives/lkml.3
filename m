Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbaCRXMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:12:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385AbaCRXL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:11:59 -0400
Date: Tue, 18 Mar 2014 16:14:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matei Oprea <eu@opreamatei.ro>
Cc: sachin.kamat@linaro.org, shaun@xresource.ca, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Subject: Re: [PATCH] staging: cxt1e1: hwprobe: Fix sparse warning
Message-ID: <20140318231401.GA2459@kroah.com>
References: <1395181999-29433-1-git-send-email-eu@opreamatei.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395181999-29433-1-git-send-email-eu@opreamatei.ro>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 12:33:19AM +0200, Matei Oprea wrote:
> This fixes the following sparse warning:
> * drivers/staging/cxt1e1/hwprobe.c:43:19: 
> warning: symbol 'hdw_info' was not declared. Should it be static?
> * drivers/staging/cxt1e1/hwprobe.c:47:1: 
> warning: symbol 'show_two' was not declared. Should it be static?
> * drivers/staging/cxt1e1/hwprobe.c:99:1: 
> warning: symbol 'hdw_sn_get' was not declared. Should it be static?
> *drivers/staging/cxt1e1/hwprobe.c:149:1: 
> warning: symbol 'prep_hdw_info' was not declared. Should it be static?
> * drivers/staging/cxt1e1/hwprobe.c:169:1: 
> warning: symbol 'cleanup_ioremap' was not declared. Should it be static?
> * drivers/staging/cxt1e1/hwprobe.c:195:1: 
> warning: symbol 'cleanup_devs' was not declared. Should it be static?
> drivers/staging/cxt1e1/hwprobe.c:293:1: 
> * warning: symbol 'c4hw_attach_all' was not declared. Should it be static?
> 
> Signed-off-by: Matei Oprea <eu@opreamatei.ro>
> Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
> ---
>  drivers/staging/cxt1e1/hwprobe.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
> index 02b4f8f..694047a 100644
> --- a/drivers/staging/cxt1e1/hwprobe.c
> +++ b/drivers/staging/cxt1e1/hwprobe.c
> @@ -40,10 +40,10 @@ void        c4_stopwd (ci_t *);
>  struct net_device * __init c4_add_dev (hdw_info_t *, int, unsigned long, unsigned long, int, int);
>  
>  
> -struct s_hdw_info hdw_info[MAX_BOARDS];
> +static struct s_hdw_info hdw_info[MAX_BOARDS];
>  
>  
> -void        __init
> +static void        __init
>  show_two (hdw_info_t *hi, int brdno)
>  {
>      ci_t       *ci;
> @@ -95,7 +95,7 @@ show_two (hdw_info_t *hi, int brdno)


This patch doesn't apply at all, did you do it against my staging-next
branch of staging.git or linux-next?  Or did you do it against Linus's
tree?  If Linus's tree, that's quite "old" for development stuff, always
work against linux-next to avoid making the same changes others already
have in the past.

greg k-h
