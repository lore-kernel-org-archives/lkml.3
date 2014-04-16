Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbaDPUBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:01:41 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:45466 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbaDPUBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:01:36 -0400
Date: Wed, 16 Apr 2014 16:01:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] ahci: Ensure "MSI Revert to Single Message" mode is
 not enforced
Message-ID: <20140416200132.GG22569@htj.dyndns.org>
References: <cover.1396426390.git.agordeev@redhat.com>
 <fe4097ff2b486092108663532c015a40984bc5f9.1396426390.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe4097ff2b486092108663532c015a40984bc5f9.1396426390.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alexander.

On Wed, Apr 02, 2014 at 10:19:56AM +0200, Alexander Gordeev wrote:
> +static int ahci_is_mrsm(struct ahci_host_priv *hpriv)
> +{
> +	void __iomem *mmio = hpriv->mmio;
> +	u32 ctl = readl(mmio + HOST_CTL);
> +
> +	return ctl & HOST_MRSM;
> +}

Can you please just open code this in ahci_init_interrupt()?  Also, do
I need to backport this through -stable?  Has this been tested
somehow?  What are the impacts of missing this?

Thanks.

-- 
tejun
