Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3GXXJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 19:09:50 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:50497 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775Ab3GXXJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 19:09:49 -0400
Message-ID: <1374707387.29835.23.camel@x61.thuisdomein>
Subject: Re: [PATCH] net: trans_rdma: remove unused function
From: Paul Bolle <pebolle@tiscali.nl>
To: David Miller <davem@davemloft.net>
Cc: andi@etezian.org, ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Jul 2013 01:09:47 +0200
In-Reply-To: <20130724.154646.2283898956674234778.davem@davemloft.net>
References: <1374497956-32104-1-git-send-email-andi@etezian.org>
	 <20130724.154646.2283898956674234778.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jul 2013 23:09:47.0260 (UTC) FILETIME=[E41F1BC0:01CE88C2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 15:46 -0700, David Miller wrote:
> From: Andi Shyti <andi@etezian.org>
> > This patch gets rid of the following warning:
> > 
> > net/9p/trans_rdma.c:594:12: warning: ‘rdma_cancelled’ defined but not used [-Wunused-function]
> >  static int rdma_cancelled(struct p9_client *client, struct p9_req_t *req)
> > 
> > The rdma_cancelled function is not called anywhere in the kernel
> > 
> > Signed-off-by: Andi Shyti <andi@etezian.org>
> 
> Applied to net-next, thanks.

After this patch one might as well revert the rest of commit
80b45261a0b2 ("9P: Add cancelled() to the transport functions.") too. It
seems the entire cancelled callback stuff is now pointless.

As I already asked in https://lkml.org/lkml/2013/7/15/87 : did that
commit "forget to actually hook up rdma_cancelled() into
p9_rdma_trans()?". It does look so to me.


Paul Bolle


