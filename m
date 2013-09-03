Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab3ICNdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:33:32 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:60799 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760070Ab3ICNcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:32:42 -0400
Date: Tue, 3 Sep 2013 09:32:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 2/4] MSI/x86: Support pci_enable_msi_block_part()
 interface
Message-ID: <20130903133238.GA10522@htj.dyndns.org>
References: <cover.1378111919.git.agordeev@redhat.com>
 <9a0ae6ff3d116109d9f61230936a5c6a057637e0.1378111919.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a0ae6ff3d116109d9f61230936a5c6a057637e0.1378111919.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 11:00:01AM +0200, Alexander Gordeev wrote:
> @@ -60,18 +60,18 @@ static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
>  	WARN_ON(msidesc->irq);
>  	WARN_ON(msidesc->msi_attrib.multiple);
>  	WARN_ON(msidesc->nvec_used);
> +	BUG_ON(nvec_mme != __roundup_pow_of_two(nvec_mme));

Wouldn't !is_power_of_2() be better?

Thanks.

-- 
tejun
