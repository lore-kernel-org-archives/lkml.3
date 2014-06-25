Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaFYJ3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbaFYJ3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:29:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1403683888.1960.35.camel@x220>
References: <1403683888.1960.35.camel@x220>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: dhowells@redhat.com, Jiri Kosina <trivial@kernel.org>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Documentation: Fix typo 'CONFIG_AFS'
Date: Wed, 25 Jun 2014 10:09:15 +0100
Message-ID: <6075.1403687355@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> wrote:

> Perhaps AF_RXRPC should be dropped from this short list (it is selected
> if AFS_FS is set). But since I couldn't actually determine how AFS_FS
> and RXKAD interact I decided to not touch that list any further.

The key_type_rxrpc key that the AFS fs or userspace passes to AF_RXRPC
indicates the protocol that AF_RXRPC should use.  The AFS fs doesn't need to
care how the security actually works and the token is opaque to it.

rxkad registers itself with AF_RXRPC, which maintains a list.  The
security_index is the number that appears in the protocol that indicates the
security driver to use.

David
