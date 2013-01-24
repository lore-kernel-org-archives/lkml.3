Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3AXKKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:10:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab3AXKKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:10:07 -0500
Date: Thu, 24 Jan 2013 11:09:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, davem@davemloft.net,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
In-Reply-To: <1358991765-22715-6-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LNX.2.00.1301241108590.31600@pobox.suse.cz>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com> <1358991765-22715-1-git-send-email-kys@microsoft.com> <1358991765-22715-6-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2013, K. Y. Srinivasan wrote:

> Execute the shutdown code in a thread context. With recent changes made to the
> shutdown code, shutdown code cannot be invoked from an interrupt context.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/hv/hv_util.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> index 8b7868a..aceb67f 100644
> --- a/drivers/hv/hv_util.c
> +++ b/drivers/hv/hv_util.c
> @@ -49,6 +49,16 @@ static struct hv_util_service util_kvp = {
>  	.util_deinit = hv_kvp_deinit,
>  };
>  
> +static void perform_shutdown(struct work_struct *dummy)
> +{
> +		orderly_poweroff(true);
> +}

Is there any particular reason for this kind of crazy indentation?

-- 
Jiri Kosina
SUSE Labs
