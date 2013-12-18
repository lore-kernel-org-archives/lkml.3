Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3LRQIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:08:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab3LRQIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:08:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1386975369-30837-1-git-send-email-khoroshilov@ispras.ru>
References: <1386975369-30837-1-git-send-email-khoroshilov@ispras.ru>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: dhowells@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RXRPC]: do not unlock unheld spinlock in rxrpc_connect_exclusive()
Date: Wed, 18 Dec 2013 16:08:35 +0000
Message-ID: <29753.1387382915@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Khoroshilov <khoroshilov@ispras.ru> wrote:

> If rx->conn is not NULL, rxrpc_connect_exclusive() does not
> acquire the transport's client lock, but it still releases it.
> 
> The patch adds locking of the spinlock to this path.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Looks good, thanks!  I've added it to my AFS branch.

David
