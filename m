Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaHKHeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:34:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbaHKHef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:34:35 -0400
Date: Mon, 11 Aug 2014 09:34:08 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 RESEND 01/23] be2iscsi: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Message-ID: <20140811073408.GA16504@dhcp-27-160.brq.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <c59d60c1d8b848222bbac6d32c314c9dfbfb13f2.1405533479.git.agordeev@redhat.com>
 <20140726080842.GB21129@agordeev.usersys.redhat.com>
 <37724B2049F71D4C9B086F99DDB2DE11571FB4AC@CMEXMB1.ad.emulex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37724B2049F71D4C9B086F99DDB2DE11571FB4AC@CMEXMB1.ad.emulex.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 11:29:51PM +0000, Jayamohan Kallickal wrote:
> 
> 
> -----Original Message-----
> From: Alexander Gordeev [mailto:agordeev@redhat.com] 
> Sent: Saturday, July 26, 2014 1:09 AM
> To: linux-kernel@vger.kernel.org; Jayamohan Kallickal
> Subject: Re: [PATCH v2 RESEND 01/23] be2iscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()
> 
> On Wed, Jul 16, 2014 at 08:05:05PM +0200, Alexander Gordeev wrote:
> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers using these 
> > two interfaces need to be updated to use the new 
> > pci_enable_msi_range()  or pci_enable_msi_exact() and 
> > pci_enable_msix_range() or pci_enable_msix_exact() interfaces.
> 
> Hi Jayamohan,
> 
> Could you please review this patch?

Jayamohan?

> Thanks!
> 
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > ---
> >  drivers/scsi/be2iscsi/be_main.c |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/scsi/be2iscsi/be_main.c 
> > b/drivers/scsi/be2iscsi/be_main.c index 56467df..1f63169 100644
> > --- a/drivers/scsi/be2iscsi/be_main.c
> > +++ b/drivers/scsi/be2iscsi/be_main.c
> > @@ -5278,12 +5278,10 @@ static void beiscsi_msix_enable(struct beiscsi_hba *phba)
> >  	for (i = 0; i <= phba->num_cpus; i++)
> >  		phba->msix_entries[i].entry = i;
> >  
> > -	status = pci_enable_msix(phba->pcidev, phba->msix_entries,
> > -				 (phba->num_cpus + 1));
> > +	status = pci_enable_msix_exact(phba->pcidev, phba->msix_entries,
> > +				       phba->num_cpus + 1);
> >  	if (!status)
> >  		phba->msix_enabled = true;
> > -
> > -	return;
> >  }
> >  
> >  static void be_eqd_update(struct beiscsi_hba *phba)
> > --
> > 1.7.7.6
> > 
> 
> 
> Looks Good.
> 
> Acked-by:  Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> --
