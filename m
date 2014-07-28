Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaG1GC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:02:57 -0400
Received: from exprod7og117.obsmtp.com ([64.18.2.6]:46853 "EHLO
	exprod7og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaG1GCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:02:55 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2014 02:02:55 EDT
From: Kashyap Desai <kashyap.desai@avagotech.com>
References: <cover.1405533479.git.agordeev@redhat.com> <3d2402ebfad625e508bb13257e1560abf92594cd.1405533479.git.agordeev@redhat.com>
 <20140726082408.GG21129@agordeev.usersys.redhat.com>
In-Reply-To: <20140726082408.GG21129@agordeev.usersys.redhat.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQISKTNo4W06vQORa1Go0+G/ciGJBQGQbGOPAmCi6mObEHX9sA==
Date: Mon, 28 Jul 2014 11:26:13 +0530
Message-ID: <3b7c554551d306e2f58f5e09dc171db2@mail.gmail.com>
Subject: RE: [PATCH v2 RESEND 13/23] megaraid: Fail resume if MSI-X
 re-initialization failed
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        Neela Syam Kolli <megaraidlinux@lsi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alexander Gordeev [mailto:agordeev@redhat.com]
> Sent: Saturday, July 26, 2014 1:54 PM
> To: linux-kernel@vger.kernel.org; Neela Syam Kolli
> Subject: Re: [PATCH v2 RESEND 13/23] megaraid: Fail resume if MSI-X re-
> initialization failed
>
> On Wed, Jul 16, 2014 at 08:05:17PM +0200, Alexander Gordeev wrote:
> > Currently the driver fails to analize MSI-X re-enablement status on
> > resuming and always assumes the success. This update checks the MSI-X
> > initialization result and fails to resume if MSI-Xs re-enablement
> > failed.
>
> Hi Neela,
>
> Could you please review megaraid patches in this series?
>
> Thanks!
Please consider this patch Acked by Me.

Acked-by: Kashyap Desai <Kashyap.desai@avagotech.com>

>
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c |    8 +++++---
> >  1 files changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index 112799b..ba06102 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -5134,9 +5134,10 @@ megasas_resume(struct pci_dev *pdev)
> >  		goto fail_ready_state;
> >
> >  	/* Now re-enable MSI-X */
> > -	if (instance->msix_vectors)
> > -		pci_enable_msix(instance->pdev, instance->msixentry,
> > -				instance->msix_vectors);
> > +	if (instance->msix_vectors &&
> > +	    pci_enable_msix(instance->pdev, instance->msixentry,
> > +			    instance->msix_vectors))
> > +		goto fail_reenable_msix;
> >
> >  	switch (instance->pdev->device) {
> >  	case PCI_DEVICE_ID_LSI_FUSION:
> > @@ -5245,6 +5246,7 @@ fail_init_mfi:
> >
> >  fail_set_dma_mask:
> >  fail_ready_state:
> > +fail_reenable_msix:
> >
> >  	pci_disable_device(pdev);
> >
> > --
> > 1.7.7.6
> >
>
> --
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
