Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaIFOKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 10:10:10 -0400
Received: from mail.us.es ([193.147.175.20]:57387 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaIFOKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 10:10:06 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19341. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-102.2/7.5):. 
 Processed in 2.556133 secs); 06 Sep 2014 14:10:02 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Sat, 6 Sep 2014 16:10:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 net-next 2/2] net: filter: split filter.h and expose
 eBPF to user space
Message-ID: <20140906141051.GA4245@salvia>
References: <1409894238-9055-1-git-send-email-ast@plumgrid.com>
 <1409894238-9055-3-git-send-email-ast@plumgrid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409894238-9055-3-git-send-email-ast@plumgrid.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 10:17:18PM -0700, Alexei Starovoitov wrote:
> allow user space to generate eBPF programs
> 
> uapi/linux/bpf.h: eBPF instruction set definition
> 
> linux/filter.h: the rest
> 
> This patch only moves macro definitions, but practically it freezes existing
> eBPF instruction set, though new instructions can still be added in the future.
> 
> These eBPF definitions cannot go into uapi/linux/filter.h, since the names
> may conflict with existing applications.
> 
> Full eBPF ISA description is in Documentation/networking/filter.txt

I think you need to have at least one single interface using this
before you can expose it to userspace. So this should come in the
small batch that introduces the first interface of your ebpf code in
userspace. AFAIK, this has been the policy so far.
