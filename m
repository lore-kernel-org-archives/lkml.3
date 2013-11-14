Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab3KNPvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:51:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab3KNPvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:51:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1384361368.5245.11.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1384361368.5245.11.camel@dhcp-9-2-203-236.watson.ibm.com> <20131104162216.10177.98067.stgit@warthog.procyon.org.uk> <20131104162300.10177.20700.stgit@warthog.procyon.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, d.kasatkin@samsung.com, zohar@us.ibm.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] KEYS: Trusted: Use key preparsing
Date: Thu, 14 Nov 2013 15:50:59 +0000
Message-ID: <7921.1384444259@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > - * trusted_instantiate - create a new trusted key
> > + * trusted_preparse - Preparse data for an trusted key
> >   *
> > - * Unseal an existing trusted blob or, for a new key, get a
> > - * random key, then seal and create a trusted key-type key,
> > - * adding it to the specified keyring.
> > + * Decrypt an existing encrypted datablob or create a new encrypted key
> > + * based on a kernel random number.
> 
> Not sure why the change in terminology from unsealing/trusted blob to
> decrypt/encrypted blob.

Because the "Unseal an existing trusted blob ..." bit is still attached to the
trusted_instantiate() function.  However, even what I wrote is still not a
good description of the trusted_preparse(), so I'll reduce it to just:

	/*
	 * trusted_preparse - Preparse the payload data for an trusted key
	 *
	 * On success, return 0. Otherwise return errno.
	 */

> trusted_preparse() always fails, since ret is initialized to -ENOMEM and
> never set.

Fixed.

Thanks,
David
