Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaHKI33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:29:29 -0400
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:40666 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaHKI31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:29:27 -0400
From: Kashyap Desai <kashyap.desai@avagotech.com>
References: <cover.1405533479.git.agordeev@redhat.com> <57071ec862e6e0cf6b1c9f7fa5c1d3b9fa97d087.1405533479.git.agordeev@redhat.com>
 <20140811080941.GI16504@dhcp-27-160.brq.redhat.com>
In-Reply-To: <20140811080941.GI16504@dhcp-27-160.brq.redhat.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQISKTNo4W06vQORa1Go0+G/ciGJBQIWH8HbAatxdCKbKB13gA==
Date: Mon, 11 Aug 2014 13:59:24 +0530
Message-ID: <313fb7f99754e9398871862f02fce2cd@mail.gmail.com>
Subject: RE: [PATCH v2 RESEND 14/23] megaraid: Use pci_enable_msix_range()
 instead of pci_enable_msix()
To: Alexander Gordeev <agordeev@redhat.com>,
        Neela Syam Kolli <megaraidlinux@avagotech.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alexander Gordeev [mailto:agordeev@redhat.com]
> Sent: Monday, August 11, 2014 1:40 PM
> To: Kashyap Desai; Neela Syam Kolli
> Cc: linux-scsi@vger.kernel.org; linux-pci@vger.kernel.org; linux-
> kernel@vger.kernel.org; Christoph Hellwig
> Subject: Re: [PATCH v2 RESEND 14/23] megaraid: Use
> pci_enable_msix_range() instead of pci_enable_msix()
>
> On Wed, Jul 16, 2014 at 08:05:18PM +0200, Alexander Gordeev wrote:
> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers using these
> > two interfaces need to be updated to use the new
> > pci_enable_msi_range()  or pci_enable_msi_exact() and
> > pci_enable_msix_range() or pci_enable_msix_exact() interfaces.
>
> Kashyap, Neela,
>
> Could you please reveiw this patch?

Review this patch. Please consider this patch Acked by Me.
 Acked-by: Kashyap Desai <Kashyap.desai@avagotech.com>

>
> Thanks!
>
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> > Cc: linux-scsi@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c |   20 +++++++-------------
> >  1 files changed, 7 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index ba06102..7a4e75e 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -4105,17 +4105,11 @@ static int megasas_init_fw(struct
> megasas_instance *instance)
> >  					     (unsigned
int)num_online_cpus());
> >  		for (i = 0; i < instance->msix_vectors; i++)
> >  			instance->msixentry[i].entry = i;
> > -		i = pci_enable_msix(instance->pdev, instance->msixentry,
> > -				    instance->msix_vectors);
> > -		if (i >= 0) {
> > -			if (i) {
> > -				if (!pci_enable_msix(instance->pdev,
> > -						     instance->msixentry,
i))
> > -					instance->msix_vectors = i;
> > -				else
> > -					instance->msix_vectors = 0;
> > -			}
> > -		} else
> > +		i = pci_enable_msix_range(instance->pdev, instance-
> >msixentry,
> > +					  1, instance->msix_vectors);
> > +		if (i)
> > +			instance->msix_vectors = i;
> > +		else
> >  			instance->msix_vectors = 0;
> >
> >  		dev_info(&instance->pdev->dev, "[scsi%d]: FW supports"
> > @@ -5135,8 +5129,8 @@ megasas_resume(struct pci_dev *pdev)
> >
> >  	/* Now re-enable MSI-X */
> >  	if (instance->msix_vectors &&
> > -	    pci_enable_msix(instance->pdev, instance->msixentry,
> > -			    instance->msix_vectors))
> > +	    pci_enable_msix_exact(instance->pdev, instance->msixentry,
> > +				  instance->msix_vectors))
> >  		goto fail_reenable_msix;
> >
> >  	switch (instance->pdev->device) {
> > --
> > 1.7.7.6
> >
