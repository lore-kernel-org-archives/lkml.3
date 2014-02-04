Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbaBDTIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:08:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbaBDTIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:08:07 -0500
Date: Tue, 4 Feb 2014 20:09:36 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 1/3] ath10k: Get rid of superfluous call to
 pci_disable_msi()
Message-ID: <20140204190935.GA1430@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
 <20140130134819.GA31909@dhcp-26-207.brq.redhat.com>
 <87y51qohjn.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y51qohjn.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 08:32:12PM +0200, Kalle Valo wrote:
> Alexander Gordeev <agordeev@redhat.com> writes:
> 
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > ---
> >  drivers/net/wireless/ath/ath10k/pci.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> > index 29fd197..6525e1f 100644
> > --- a/drivers/net/wireless/ath/ath10k/pci.c
> > +++ b/drivers/net/wireless/ath/ath10k/pci.c
> > @@ -2414,8 +2414,6 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
> >  		ret = pci_enable_msi_block(ar_pci->pdev, ar_pci->num_msi_intrs);
> >  		if (ret == 0)
> >  			return 0;
> > -		if (ret > 0)
> > -			pci_disable_msi(ar_pci->pdev);
> 
> I don't understand how this is superfluous. When I read the
> documentation for pci_enable_msi_block() it states that if it can't
> allocate all requests, it will return the number requests it could
> allocate. And in that case we want to fall back other modes.
> 
> Am I missing something?

Yep. The documentation states 'could have been allocated', not 'could
allocate'. IOW, MSIs are *not* enabled if a positive value returned.
The code I changed tries to disable MSIs in such case, although it is
not necessary, nor required. Just superfluous.

HTH.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
