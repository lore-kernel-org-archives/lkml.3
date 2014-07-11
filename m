Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaGKVCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:02:14 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20031 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaGKVCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:02:11 -0400
Date: Fri, 11 Jul 2014 17:02:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: konrad@kernel.org, xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/5] xen/pciback: Don't deadlock when unbinding.
Message-ID: <20140711210201.GC25233@laptop.dumpdata.com>
References: <1405109332-31659-1-git-send-email-konrad@kernel.org>
 <1405109332-31659-3-git-send-email-konrad@kernel.org>
 <53C04D81.3010002@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C04D81.3010002@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >--- a/drivers/xen/xen-pciback/pci_stub.c
> >+++ b/drivers/xen/xen-pciback/pci_stub.c
> >@@ -250,6 +250,8 @@ struct pci_dev *pcistub_get_pci_dev(struct xen_pcibk_device *pdev,
> >   *  - 'echo BDF > unbind' with a guest still using it. See pcistub_remove
> >   *
> >   *  As such we have to be careful.
> >+ *
> >+ *  To make this easier, the caller has to hold the device lock.
> 
> Should we assert that the lock is being held?

Yes of course we should. Thank you!
