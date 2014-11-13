Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934678AbaKMXHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:07:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934347AbaKMXHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:07:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <546528BF.5040902@gmail.com>
References: <546528BF.5040902@gmail.com> <1415906662-4576-17-git-send-email-bobby.prani@gmail.com> <1415906662-4576-1-git-send-email-bobby.prani@gmail.com> <24601.1415911646@warthog.procyon.org.uk>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 16/16] rxrpc: Replace smp_read_barrier_depends() with lockless_dereference()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26068.1415920047.1@warthog.procyon.org.uk>
Date: Thu, 13 Nov 2014 23:07:27 +0000
Message-ID: <26069.1415920047@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranith Kumar <bobby.prani@gmail.com> wrote:

> OK. Should I send in a patch removing these barriers then?

No.  There need to be stronger barriers, at least in some of the cases.
circular-buffers.txt details what is required, but not all of the cases match
the pattern there, so it needs a bit more consideration.

David
