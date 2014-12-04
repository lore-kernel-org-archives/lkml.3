Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaLDNDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:03:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbaLDNDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:03:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5480529B.7010101@samsung.com>
References: <5480529B.7010101@samsung.com> <20141120165351.5264.61930.stgit@warthog.procyon.org.uk> <20141120165403.5264.18275.stgit@warthog.procyon.org.uk> <20141121144245.GA22306@redhat.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, Vivek Goyal <vgoyal@redhat.com>, mmarek@suse.cz,
        rusty@rustcorp.com.au, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] X.509: Extract both parts of the AuthorityKeyIdentifier
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25691.1417698175.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Thu, 04 Dec 2014 13:02:55 +0000
Message-ID: <25692.1417698175@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> >> -	struct asymmetric_key_id *authority;	/* Authority key identifier (optional) */
> >> +	struct asymmetric_key_id *auth_id;	/* CA AuthKeyId matching ->id (optional) */
> >> +	struct asymmetric_key_id *auth_skid;	/* CA AuthKeyId matching ->skid (optional) */
> > A very minor nit. It might help if we put additional comment to explain what
> > auth_id and auth_skid are composed of (like other key ids).
> >
> > auth_id /* akid issuer + akid serial */
> > auth_skid /* issuer + akid keyid */
> >
> > Thanks
> > Vivek
> >
> 
> Right,
> 
> David did not address this in his v2 patchset...

I decided against changing them on the basis that I'd prefer to show what they
match over the way they are fabricated.  The id and skid members do show how
they are fabricated.  If you really want, I can show both - but my thought is
that if you look at how AuthorityKeyIdentifier is constructed, you can work it
out reasonably easily.

David
