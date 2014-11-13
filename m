Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160AbaKMULg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:11:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933468AbaKMULe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:11:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1415906662-4576-7-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-7-git-send-email-bobby.prani@gmail.com> <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: dhowells@redhat.com, James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Hemminger <shemming@brocade.com>,
        Andreea-Cristina Bernat <bernat.ada@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        keyrings@linux-nfs.org (open list:KEYS/KEYRINGS:),
        linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM),
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 06/16] assoc_array: Replace smp_read_barrier_depends() with lockless_dereference()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24279.1415909476.1@warthog.procyon.org.uk>
Date: Thu, 13 Nov 2014 20:11:16 +0000
Message-ID: <24280.1415909476@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranith Kumar <bobby.prani@gmail.com> wrote:

>  static inline bool assoc_array_ptr_is_meta(const struct assoc_array_ptr *x)
>  {
> -	return (unsigned long)x & ASSOC_ARRAY_PTR_TYPE_MASK;
> +	return (unsigned long)lockless_dereference(x) &
> +						ASSOC_ARRAY_PTR_TYPE_MASK;
>  }

Nack.  x is not being dereferenced here, nor in some of the other places
you've added this.

David
