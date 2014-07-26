Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbaGZKSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 06:18:41 -0400
Received: from mail.us.es ([193.147.175.20]:42332 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaGZKSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 06:18:39 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19227. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-100.2/7.5):. 
 Processed in 3.073153 secs); 26 Jul 2014 10:18:37 -0000
X-Spam-ASN: AS42863 89.214.0.0/16
X-Envelope-From: pneira@us.es
Date: Sat, 26 Jul 2014 12:18:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Willem de Bruijn <willemb@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: filter: rename 'struct sk_filter' to
 'struct bpf_prog'
Message-ID: <20140726101847.GA3703@salvia>
References: <1406315469-20010-1-git-send-email-ast@plumgrid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406315469-20010-1-git-send-email-ast@plumgrid.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 12:11:09PM -0700, Alexei Starovoitov wrote:
> 'sk_filter' name is used as 'struct sk_filter', function sk_filter() and
> as variable 'sk_filter', which makes code hard to read.
> Also it's easily confused with 'struct sock_filter'
> Rename 'struct sk_filter' to 'struct bpf_prog' to clarify semantics and
> align the name with generic BPF use model.
> 
> The only ugly place is uapi/linux/netfilter/xt_bpf.h which
> managed to expose kernel internal structure into uapi header.
> So replace 'struct sk_filter *' there with 'void *' and type cast it
> to 'struct bpf_prog *' inside kernel in net/netfilter/xt_bpf.c
> 
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
> v1->v2:
> replace 'struct sk_filter *' with 'void *' in uapi/../xt_bpf.h
> (seems Daniel and Willem prefere this option)

Please, we're still discussing this in the original thread:

http://marc.info/?l=netfilter-devel&m=140632686726741&w=2
http://marc.info/?l=netfilter-devel&m=140632663526671&w=2

And don't trim me off from the CC. Thanks.
