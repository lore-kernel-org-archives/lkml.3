Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934324AbaDITYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:24:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933402AbaDITYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:24:34 -0400
Date: Wed, 9 Apr 2014 12:27:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Cc: *S-Par-Maintainer <SParMaintainer@unisys.com>,
        "jkc@redhat.com" <jkc@redhat.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unisys: staging: Check for s-Par firmware before
 initializing s-Par modules
Message-ID: <20140409192705.GB11506@kroah.com>
References: <C97001BC43954D438ACB059713BA5CDF92040F0F09@USEA-EXCH7.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C97001BC43954D438ACB059713BA5CDF92040F0F09@USEA-EXCH7.na.uis.unisys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 02:04:50PM -0500, Romer, Benjamin M wrote:
> @@ -71,5 +71,6 @@
>  				  u64 somethings, char *buf, size_t bufsize);
>  struct seq_file *visor_seq_file_new_buffer(void *buf, size_t buf_size);
>  void visor_seq_file_done_buffer(struct seq_file *m);
> +int is_spar_system( void );

That's a horrid function name to polute the global namespace, please be
more "unique".




>  
>  #endif
> diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
> index 8ea9c46..aa60ccb 100644
> --- a/drivers/staging/unisys/uislib/uislib.c
> +++ b/drivers/staging/unisys/uislib/uislib.c
> @@ -1,6 +1,6 @@
>  /* uislib.c
>   *
> - * Copyright � 2010 - 2013 UNISYS CORPORATION
> + * Copyright © 2010 - 2013 UNISYS CORPORATION
>   * All rights reserved.
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -2276,6 +2276,11 @@
>  static int __init
>  uislib_mod_init(void)
>  {
> +	/* check for s-Par support */
> +	if( !is_spar_system() ) {
> +		printk( "s-Par not detected.\n" );
> +		return -EPERM;
> +	}

Always run your patches through scripts/checkpatch.pl so I don't reject
them for the things it points out...


thanks,

greg k-h
