Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab3DXRxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 13:53:14 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:58329 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3DXRxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 13:53:12 -0400
Date: Wed, 24 Apr 2013 14:53:04 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org,
        Vipul Pandya <vipul@chelsio.com>
Subject: Re: linux-next: manual merge of the net-next tree with the
 infiniband tree
Message-ID: <20130424175304.GA701@oc0268524204.ibm.com>
References: <20130418131843.bfeb6b1ad5fba1b0f706076e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418131843.bfeb6b1ad5fba1b0f706076e@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042417-2362-0000-0000-00000A6A4E20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 01:18:43PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in
> drivers/infiniband/hw/cxgb4/qp.c between commit 5b0c275926b8
> ("RDMA/cxgb4: Fix SQ allocation when on-chip SQ is disabled") from the
> infiniband tree and commit 9919d5bd01b9 ("RDMA/cxgb4: Fix onchip queue
> support for T5") from the net-next tree.
> 
> I think that they are 2 different fixes for the same problem, so I just
> used the net-next version and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


Commit 5b0c275926b8 also keeps the intention of the original patch which
broke it, which was to return an error code, in case the allocation fails.
Commit 9919d5bd01b9 fix will return 0 in case the allocation fails.

We should keep the other fix or fix the code again to return the proper
error code.

Regards.
Cascardo.

