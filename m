Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaJKUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 16:16:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaJKUQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 16:16:29 -0400
Date: Sat, 11 Oct 2014 13:15:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Filipe =?iso-8859-1?Q?Gon=E7alves?= <filipe@codinghighway.com>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/staging: Fixed sparse error "directive in
 argument list"
Message-ID: <20141011201523.GA29341@kroah.com>
References: <1413054822-7894-1-git-send-email-filipe@codinghighway.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413054822-7894-1-git-send-email-filipe@codinghighway.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 08:13:42PM +0100, Filipe Gonçalves wrote:
> This patch fixes a sparse warning on layout.c (ptlrpc) that was caused by having preprocessor directives in the arguments to a macro.
> 
> Signed-off-by: Filipe Gonçalves <filipe@codinghighway.com>
> ---
>  drivers/staging/lustre/lustre/ptlrpc/layout.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
> index 5b83371..211df78 100644
> --- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
> +++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
> @@ -978,10 +978,11 @@ struct req_msg_field RMF_CONN =
>  EXPORT_SYMBOL(RMF_CONN);
>  
>  struct req_msg_field RMF_CONNECT_DATA =
> +#if LUSTRE_VERSION_CODE > OBD_OCD_VERSION(2, 7, 50, 0)
>  	DEFINE_MSGF("cdata",
>  		    RMF_F_NO_SIZE_CHECK /* we allow extra space for interop */,
> -#if LUSTRE_VERSION_CODE > OBD_OCD_VERSION(2, 7, 50, 0)
>  		    sizeof(struct obd_connect_data),
> +		    lustre_swab_connect, NULL);

Ick ick ick.

Yeah, sparse might complain about this, but how about just properly
deleting the #ifdef entirely, and not perpetuate it even more?

It shouldn't be needed anymore now that the code is in the kernel tree.

greg k-h
