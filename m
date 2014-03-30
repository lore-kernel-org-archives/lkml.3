Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaC3LfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 07:35:11 -0400
Received: from mail.us.es ([193.147.175.20]:42961 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbaC3LfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 07:35:08 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.1/18714. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-99.8/7.5):. 
 Processed in 1.977132 secs); 30 Mar 2014 11:35:07 -0000
X-Spam-ASN: AS12715 95.20.0.0/16
X-Envelope-From: pneira@us.es
Date: Sun, 30 Mar 2014 13:35:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, vvs@parallels.com,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] netfilter: nf_conntrack: reserve two bytes for
 nf_ct_ext->len (v3)
Message-ID: <20140330113504.GA5895@localhost>
References: <20140328092449.GA20844@paralelels.com>
 <1396000472-6130-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396000472-6130-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 01:54:32PM +0400, Andrey Vagin wrote:
> "len" contains sizeof(nf_ct_ext) and size of extensions. In a worst
> case it can contain all extensions. Bellow you can find sizes for all
> types of extensions. Their sum is definitely bigger than 256.
> 
> nf_ct_ext_types[0]->len = 24
> nf_ct_ext_types[1]->len = 32
> nf_ct_ext_types[2]->len = 24
> nf_ct_ext_types[3]->len = 32
> nf_ct_ext_types[4]->len = 152
> nf_ct_ext_types[5]->len = 2
> nf_ct_ext_types[6]->len = 16
> nf_ct_ext_types[7]->len = 8
> 
> I have seen "len" up to 280 and my host has crashes w/o this patch.
> 
> The right way to fix this problem is reducing the size of the ecache
> extension (4) and Florian is going to do this, but these changes will
> be quite large to be appropriate for a stable tree.
> 
> v2: rearrange the extension so ECACHE comes last. This is required to
> prevent overflow of nf_ct_ext->offset.
> v3: The previous attempt of rearranging constants doesn't work here,
> because extensions may be added in a random order.

Applied, thanks.
