Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934200AbaKMURw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:17:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296AbaKMURv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:17:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1415906662-4576-17-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-17-git-send-email-bobby.prani@gmail.com> <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list), paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 16/16] rxrpc: Replace smp_read_barrier_depends() with lockless_dereference()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24349.1415909859.1@warthog.procyon.org.uk>
Date: Thu, 13 Nov 2014 20:17:39 +0000
Message-ID: <24350.1415909859@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranith Kumar <bobby.prani@gmail.com> wrote:

>  	     loop != call->acks_head || stop;
>  	     loop = (loop + 1) &  (call->acks_winsz - 1)
>  	     ) {
> -		p_txb = call->acks_window + loop;
> -		smp_read_barrier_depends();
> +		p_txb = lockless_dereference(call)->acks_window + loop;

Nack.  You've stuck an implicit barrier on a dereference that doesn't matter.
And similar for other hunks of this patch.

David
