Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935840AbaH0T07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:26:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51817 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935586AbaH0T06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:26:58 -0400
Message-ID: <53FE30F7.802@infradead.org>
Date: Wed, 27 Aug 2014 12:26:47 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Ian Abbott <abbotti@mev.co.uk>, devel@linuxdriverproject.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: Kconfig: make COMEDI_BOND select COMEDI_KCOMEDILIB
References: <1409167172-987-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1409167172-987-1-git-send-email-abbotti@mev.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/14 12:19, Ian Abbott wrote:
> Currently, to select the "comedi_bond" driver, the "kcomedilib" support
> has to be selected first.  It seems more natural to allow the
> "comedi_bond" driver to be selected on its own and to automatically
> select the "kcomedilib" module as a result of that.  Change the
> dependency/select relationship between the two configuration options to
> do that.
> 
> Also, make "kcomedilib" a module that can be selected independently,
> perhaps for use by out-of-tree modules, although it is not terribly
> useful for anything other than "comedi_bond" currently.
> 
> Also, improve the help text for the config options.
> 
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/Kconfig | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
> index 7d6cebc..c18e6e9 100644
> --- a/drivers/staging/comedi/Kconfig
> +++ b/drivers/staging/comedi/Kconfig
> @@ -42,18 +42,15 @@ menuconfig COMEDI_MISC_DRIVERS
>  
>  if COMEDI_MISC_DRIVERS
>  
> -config COMEDI_KCOMEDILIB
> -	tristate "Comedi kcomedilib"
> -	---help---
> -	  Build the kcomedilib
> -
>  config COMEDI_BOND
> -	tristate "Device bonding support"
> -	depends on COMEDI_KCOMEDILIB
> +	tristate "Comedi device bonding support"
> +	select COMEDI_KCOMEDILIB
>  	---help---
>  	  Enable support for a driver to 'bond' (merge) multiple subdevices
>  	  from multiple devices together as one.
>  
> +	  Currently, it only handles digital I/O subdevices.
> +
>  	  To compile this driver as a module, choose M here: the module will be
>  	  called comedi_bond.
>  
> @@ -1272,6 +1269,20 @@ config COMEDI_8255
>  	  To compile this driver as a module, choose M here: the module will be
>  	  called 8255.
>  
> +config COMEDI_KCOMEDILIB
> +	tristate "Comedi kcomedilib"
> +	---help---
> +	  Build the kcomedilib.
> +
> +	  This is a kernel module used to open and manipulate Comedi devices
> +	  from within kernel code.  It is currently only used by the
> +	  comedi_bond driver, and it's functionality has been stripped

	                          its

> +	  down to the needs of that driver, so is currently not very useful
> +	  for anything else.
> +
> +	  To compile kcomedilib as a module, choose M here: the module will be
> +	  called kcomedilib.
> +
>  config COMEDI_FC
>  	tristate
>  
> 


-- 
~Randy
