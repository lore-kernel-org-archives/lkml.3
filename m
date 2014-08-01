Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbaHAMeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:34:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbaHAMd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:33:56 -0400
Date: Fri, 1 Aug 2014 05:33:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com,
        thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1.3 6/18] arcmsr: precise checking adapter ID
Message-ID: <20140801123352.GA30397@infradead.org>
References: <1406882870.10378.55.camel@Centos6.3-64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406882870.10378.55.camel@Centos6.3-64>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -static void arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
> +static bool arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
>  {
>  	struct pci_dev *pdev = acb->pdev;
>  	u16 dev_id;
> +
>  	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
>  	acb->dev_id = dev_id;

This is already available through pdev->device.


>  		acb->adapter_type = ACB_ADAPTER_TYPE_C;

Just store the adapter type in the pci_device_id private data field,
that way you enumerate the type in the same place the ids are added
and you'll never miss adding them to a switch value.

