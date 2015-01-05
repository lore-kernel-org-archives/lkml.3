Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbbAEQBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:01:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbbAEQBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:01:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1419918382-4758-1-git-send-email-bobby.prani@gmail.com>
References: <1419918382-4758-1-git-send-email-bobby.prani@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: dhowells@redhat.com, James Morris <james.l.morris@oracle.com>,
        Andreea-Cristina Bernat <bernat.ada@gmail.com>,
        Stephen Hemminger <shemming@brocade.com>,
        Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] assoc_array: Include rcupdate.h for call_rcu() definition
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <798.1420473702.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 05 Jan 2015 16:01:42 +0000
Message-ID: <799.1420473702@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranith Kumar <bobby.prani@gmail.com> wrote:

> Include rcupdate.h header to provide call_rcu() definition. This was implicitly
> being provided by slab.h file which include srcu.h somewhere in its include
> hierarchy which in-turn included rcupdate.h. 
> 
> Lately, tinification effort added support to remove srcu entirely because of
> which we are encountering build errors like
> 
> lib/assoc_array.c: In function 'assoc_array_apply_edit':
> lib/assoc_array.c:1426:2: error: implicit declaration of function 'call_rcu' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> 
> Fix these by including rcupdate.h explicitly.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> Reported-by: Scott Wood <scottwood@freescale.com>

Applied.
