Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab3KTQHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:07:30 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:36761 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3KTQHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:07:21 -0500
Date: Wed, 20 Nov 2013 11:07:16 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 06/29] PCI/MSI: Get rid of useless count of
 msi_desc leftovers
Message-ID: <20131120160716.GF28946@htj.dyndns.org>
References: <cover.1382103786.git.agordeev@redhat.com>
 <79a2aeb6a06563c5f09463d53d2e0146e44c92be.1382103786.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79a2aeb6a06563c5f09463d53d2e0146e44c92be.1382103786.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alexander.

On Fri, Oct 18, 2013 at 07:12:06PM +0200, Alexander Gordeev wrote:
> @@ -744,23 +744,6 @@ static int msix_capability_init(struct pci_dev *dev,
>  
>  	return 0;
>  
> -out_avail:
> -	if (ret < 0) {
> -		/*
> -		 * If we had some success, report the number of irqs
> -		 * we succeeded in setting up.
> -		 */
> -		struct msi_desc *entry;
> -		int avail = 0;
> -
> -		list_for_each_entry(entry, &dev->msi_list, list) {
> -			if (entry->irq != 0)
> -				avail++;
> -		}
> -		if (avail != 0)
> -			ret = avail;
> -	}

Hmmm... so, before this, the function would have returned the partial
number of irqs that arch set up successfully.  Is it okay to lose that
information?  If so, can you please elaborate a bit more on why it's
okay in the description?

Thanks.

-- 
tejun
