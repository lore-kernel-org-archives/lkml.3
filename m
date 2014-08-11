Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaHKIzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:55:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaHKIzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:55:01 -0400
Date: Mon, 11 Aug 2014 10:54:34 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH v2 RESEND 22/23] qla4xxx: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Message-ID: <20140811085433.GL16504@dhcp-27-160.brq.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <0496ccbc0f203afaeeb7758c146b93c2f387684c.1405533479.git.agordeev@redhat.com>
 <20140726084137.GL21129@agordeev.usersys.redhat.com>
 <3FC4AB8B47ECD546BCD4B361A64BEACD8C6CAFD2@avmb3.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3FC4AB8B47ECD546BCD4B361A64BEACD8C6CAFD2@avmb3.qlogic.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 11:47:19AM +0000, Vikas Chaudhary wrote:
> 
> Acked-By: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Christoph,

This patch seems ready..

> On 26/07/14 2:11 pm, "Alexander Gordeev" <agordeev@redhat.com> wrote:
> 
> >On Wed, Jul 16, 2014 at 08:05:26PM +0200, Alexander Gordeev wrote:
> >> As result of deprecation of MSI-X/MSI enablement functions
> >> pci_enable_msix() and pci_enable_msi_block() all drivers
> >> using these two interfaces need to be updated to use the
> >> new pci_enable_msi_range()  or pci_enable_msi_exact()
> >> and pci_enable_msix_range() or pci_enable_msix_exact()
> >> interfaces.
> >
> >Hi Vikas,
> >
> >Could you please reveiw this patch?
> >
> >Thanks!
> >
> >> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> >> Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> >> Cc: iscsi-driver@qlogic.com
> >> Cc: linux-scsi@vger.kernel.org
> >> Cc: linux-pci@vger.kernel.org
> >> Acked-By: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> >> ---
> >>  drivers/scsi/qla4xxx/ql4_nx.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >> 
> >> diff --git a/drivers/scsi/qla4xxx/ql4_nx.c
> >>b/drivers/scsi/qla4xxx/ql4_nx.c
> >> index 9dbdb4b..7c33658 100644
> >> --- a/drivers/scsi/qla4xxx/ql4_nx.c
> >> +++ b/drivers/scsi/qla4xxx/ql4_nx.c
> >> @@ -4221,7 +4221,7 @@ qla4_8xxx_enable_msix(struct scsi_qla_host *ha)
> >>  	for (i = 0; i < QLA_MSIX_ENTRIES; i++)
> >>  		entries[i].entry = qla4_8xxx_msix_entries[i].entry;
> >>  
> >> -	ret = pci_enable_msix(ha->pdev, entries, ARRAY_SIZE(entries));
> >> +	ret = pci_enable_msix_exact(ha->pdev, entries, ARRAY_SIZE(entries));
> >>  	if (ret) {
> >>  		ql4_printk(KERN_WARNING, ha,
> >>  		    "MSI-X: Failed to enable support -- %d/%d\n",
> >> -- 
> >> 1.7.7.6
> >> 
> >
> >-- 
> >Regards,
> >Alexander Gordeev
> >agordeev@redhat.com
> 
