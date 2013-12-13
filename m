Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3LMQSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:18:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22309 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3LMQSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:18:23 -0500
Date: Fri, 13 Dec 2013 11:18:13 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        gordan@bobich.net
Subject: Re: [RFC PATCH 5/5] xen/pciback: PCI reset slot or bus
Message-ID: <20131213161813.GA8794@phenom.dumpdata.com>
References: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
 <1386950978-8628-6-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386950978-8628-6-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* Called when 'bind' */
>  static int pcistub_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  {
>  	int err = 0;
> @@ -528,6 +617,7 @@ out:
>  	return err;
>  }
>  
> +/* Called when 'unbind' */
>  static void pcistub_remove(struct pci_dev *dev)
>  {
>  	struct pcistub_device *psdev, *found_psdev = NULL;
> @@ -1183,7 +1273,7 @@ static ssize_t pcistub_irq_handler_show(struct device_driver *drv, char *buf)
>  			continue;
>  		count +=
>  		    scnprintf(buf + count, PAGE_SIZE - count,
> -			      "%s:%s:%sing:%ld\n",
> +			      "%s:%s:%sing:%ld:%s\n",

Um.. clearly it is RFC :-)

>  			      pci_name(psdev->dev),
>  			      dev_data->isr_on ? "on" : "off",
>  			      dev_data->ack_intr ? "ack" : "not ack",
> -- 
> 1.8.3.1
> 
