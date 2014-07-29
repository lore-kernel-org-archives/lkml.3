Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaG2PiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:38:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaG2PiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:38:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <53CE8862.7020201@adfin.com>
References: <53CE8862.7020201@adfin.com> <cover.1406043029.git.milosz@adfin.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "NeilBrown" <neilb@suse.de>, "Shantanu Goel" <sgoel01@yahoo.com>
Subject: Re: [PATCH 2/3] FS-Cache: Reduce cookie ref count if submit fails.
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28625.1406648278.1@warthog.procyon.org.uk>
Date: Tue, 29 Jul 2014 16:37:58 +0100
Message-ID: <28626.1406648278@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> wrote:

> +	wake_cookie = __fscache_unuse_cookie(cookie);
>  	spin_unlock(&cookie->lock);
> +	if (wake_cookie)
> +		__fscache_wake_unused_cookie(cookie);

Why do __fscache_unuse_cookie() with cookie->lock held?

David
