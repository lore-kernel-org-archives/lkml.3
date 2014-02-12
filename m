Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaBLUnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:43:35 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45040 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbaBLUnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:43:33 -0500
Date: Wed, 12 Feb 2014 12:43:08 -0800
From: Kees Cook <kees@outflux.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com
Subject: flaw in "nf_tables: add reject module for NFPROTO_INET"
Message-ID: <20140212204307.GK23300@outflux.net>
References: <52fb24097b42_6b5073486c727c3@209.249.196.67.mail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52fb24097b42_6b5073486c727c3@209.249.196.67.mail>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This seems like a legit problem detected by Coverity. Looks like a break is
missing?

-Kees

On Tue, Feb 11, 2014 at 11:34:33PM -0800, scan-admin@coverity.com wrote:
> 
> Hi,
> 
> 
> Please find the latest report on new defect(s) introduced to Linux found with Coverity Scan.
> 
> Defect(s) Reported-by: Coverity Scan
> Showing 1 of 1 defect(s)
> 
> 
> ** CID 1171942:  Missing break in switch  (MISSING_BREAK)
> /net/netfilter/nft_reject_inet.c: 25 in nft_reject_inet_eval()
> 
> 
> ________________________________________________________________________________________________________
> *** CID 1171942:  Missing break in switch  (MISSING_BREAK)
> /net/netfilter/nft_reject_inet.c: 25 in nft_reject_inet_eval()
> 19     				 struct nft_data data[NFT_REG_MAX + 1],
> 20     				 const struct nft_pktinfo *pkt)
> 21     {
> 22     	switch (pkt->ops->pf) {
> 23     	case NFPROTO_IPV4:
> 24     		nft_reject_ipv4_eval(expr, data, pkt);
> >>>     CID 1171942:  Missing break in switch  (MISSING_BREAK)
> >>>     The above case falls through to this one.
> 25     	case NFPROTO_IPV6:
> 26     		nft_reject_ipv6_eval(expr, data, pkt);
> 27     	}
> 28     }
> 29     
> 30     static struct nft_expr_type nft_reject_inet_type;

-- 
Kees Cook                                            @outflux.net
