Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934410AbaFCXTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:19:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933972AbaFCXTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:19:39 -0400
Date: Tue, 3 Jun 2014 16:23:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Francesco Ruggeri <fruggeri@aristanetworks.com>
Cc: linux-kernel@vger.kernel.org, hare@suse.de, linux@roeck-us.net,
        fruggeri@arista.com
Subject: Re: pci: kernel crash in bus_find_device
Message-ID: <20140603232317.GB15247@kroah.com>
References: <20140603225502.F1C5122C07D5@bs320.sjc.aristanetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603225502.F1C5122C07D5@bs320.sjc.aristanetworks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:55:02PM -0700, Francesco Ruggeri wrote:
> @@ -719,6 +719,11 @@ struct pci_dev *pci_get_device(unsigned 
>  struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
>  				unsigned int ss_vendor, unsigned int ss_device,
>  				struct pci_dev *from);
> +struct pci_dev *pci_get_device_noref(unsigned int vendor, unsigned int device,
> +				     struct pci_dev *from);
> +struct pci_dev *pci_get_subsys_noref(unsigned int vendor, unsigned int device,
> +				     unsigned int ss_vendor, unsigned int ss_device,
> +				     struct pci_dev *from);

To follow up, what drivers are you thinking need to make these calls?
Perhaps they shouldn't be doing something like this?

And, to answer my previous question, the reason PCI is different is that
drivers want to walk the list of devices to find "stupid" things like
this out, USB doesn't do dumb stuff like that :)

thanks,

greg k-h
