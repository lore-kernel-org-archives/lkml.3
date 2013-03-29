Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3C2Pts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 11:49:48 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43672 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab3C2Ptr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:49:47 -0400
Date: Fri, 29 Mar 2013 08:49:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [char-misc-next 08/11 V5] mei: nfc: Initial nfc implementation
Message-ID: <20130329154945.GB21990@kroah.com>
References: <1364398203-11159-1-git-send-email-tomas.winkler@intel.com>
 <1364398203-11159-9-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364398203-11159-9-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 05:30:00PM +0200, Tomas Winkler wrote:
> --- a/drivers/misc/mei/mei_dev.h
> +++ b/drivers/misc/mei/mei_dev.h
> @@ -498,6 +498,34 @@ struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
>  
>  void mei_amthif_run_next_cmd(struct mei_device *dev);
>  
> +#ifdef CONFIG_INTEL_MEI_BUS_NFC
> +/*
> + * NFC functions
> + */
> +int mei_nfc_host_init(struct mei_device *dev);
> +void mei_nfc_host_exit(void);
> +
> +/*
> + * NFC Client UUID
> + */
> +extern const uuid_le mei_nfc_guid;
> +
> +#else /* CONFIG_INTEL_MEI_BUS_NFC */
> +
> +static inline int mei_nfc_host_init(struct mei_device *dev)
> +{
> +	return 0;
> +}
> +
> +static inline void mei_nfc_host_exit(void)
> +{
> +	return;
> +}
> +
> +static const uuid_le mei_nfc_guid = UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50,
> +					    0x94, 0xd4, 0x50, 0x26,
> +					    0x67, 0x23, 0x77, 0x5c);
> +#endif /* CONFIG_INTEL_MEI_BUS_NFC */


As you are using the bus model, why do you need "fake" init and exit
functions at all?  Your core shouldn't care about if the nfc code is
build or not, that's why we have driver model in the first place...

greg k-h
