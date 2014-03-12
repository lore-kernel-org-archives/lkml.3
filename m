Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaCLJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:27:16 -0400
Received: from mail.us.es ([193.147.175.20]:48581 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbaCLJ1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:27:12 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.1/18582. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-98.0/7.5):. 
 Processed in 1.937545 secs); 12 Mar 2014 09:27:10 -0000
X-Spam-ASN: AS12715 188.78.0.0/16
X-Envelope-From: pneira@us.es
Date: Wed, 12 Mar 2014 10:27:07 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>, kaber@trash.net,
        Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 0/9] socket filtering using nf_tables
Message-ID: <20140312092707.GA4973@localhost>
References: <1394529560-3490-1-git-send-email-pablo@netfilter.org>
 <531EE5A2.7090501@redhat.com>
 <CAMEtUuyJne-8uNtOAK7EcFFQNXz9m7J2DDLGH_GbYe6oWZx1pQ@mail.gmail.com>
 <20140312091500.GA4638@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312091500.GA4638@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 10:15:00AM +0100, Pablo Neira Ayuso wrote:
> > 7/9:
> > whole nft_expr_autoload() looks scary from security point of view.
> > If I'm reading it correctly, the code will do request_module() based on
> > userspace request to attach filter?
> 
> Only root can invoke that code so far.

Oops, this is obviously wrong. This request_module part needs a fix
indeed for the non-root part.
