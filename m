Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3D2Jvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:51:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40673 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab3D2Jvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:51:52 -0400
Date: Mon, 29 Apr 2013 10:51:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Inki Dae <inki.dae@samsung.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] module: fix mutiple defined issue
Message-ID: <20130429095138.GJ14496@n2100.arm.linux.org.uk>
References: <1367213521-26795-1-git-send-email-inki.dae@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367213521-26795-1-git-send-email-inki.dae@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 02:32:01PM +0900, Inki Dae wrote:
> This patch fixes mutiple defined issue to MODULE_DEVICE_TABLE
> 
> The issue could be induced when some framework which includes two
> more sub drivers, is built as one moudle because those sub drivers
> could have their own MODULE_DEVICE_TABLE.
> 
> And 'struct of_device_id' isn't needed to be determined by type
> argument because the definition of 'of_device_id' should be fixed.
> So this patch makes 'of_devce_id' definition to be fixed and
> only its instance name to be defined by type.
> 
> Signed-off-by: Inki Dae <inki.dae@samsung.com>
> ---
>  include/linux/module.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 46f1ea0..ac5d79f 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -84,7 +84,7 @@ void trim_init_extable(struct module *m);
>  
>  #ifdef MODULE
>  #define MODULE_GENERIC_TABLE(gtype,name)			\
> -extern const struct gtype##_id __mod_##gtype##_table		\
> +extern const struct of_device_id __mod_##gtype##_table		\
>    __attribute__ ((unused, alias(__stringify(name))))
>  
>  #else  /* !MODULE */

This patch (a) looks wrong (why would a generic device table be limited
to of_device_id when it could be ISAPNP or something else?) and (b) how
does changing the type fix the "multiple defined issue" ?  (c) include
the errors that you're fixing in the commit log.
