Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaJCMNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:13:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaJCMNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:13:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <542D741D.5070109@samsung.com>
References: <542D741D.5070109@samsung.com> <20140908153704.28301.41578.stgit@warthog.procyon.org.uk> <20140908153830.28301.37880.stgit@warthog.procyon.org.uk>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, keyrings@linux-nfs.org,
        jwboyer@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, pjones@redhat.com,
        vgoyal@redhat.com
Subject: Re: [PATCH 08/13] KEYS: Overhaul key identification when searching for asymmetric keys
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28437.1412338372.1@warthog.procyon.org.uk>
Date: Fri, 03 Oct 2014 13:12:52 +0100
Message-ID: <28438.1412338372@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> Also I noticed that output of 'keyctl show' and 'cat /proc/keys' output
> also has changed in respect of certificate ids..
> 
> Those ids does not look any close to my kernel X509 X509v3 Subject Key
> Identifier, which is:
> 92:63:05:D6:DD:A6:6F:47:13:9E:B4:E3:CB:25:A6:AD:EF:52:7F:08
> 
> proc/keys shows
> 
> symmetri Magrathea: Glacier signing key: d9e2e4c6951f1e83: X509.RSA
> 6865612e68326732 []
> 
> Very different ids..
> 
> How could I match certificate now?

There are two IDs available:

	id: serial number + issuer
	skid: subjKeyId + subject

You can use either of them and their content is somewhat negotiable.  Note
that they are both compound IDs at this point.

We have to move away from using subjKeyId for module signatures because we
have to be able to deal with keys that don't have one.  Blech, but the PKCS
specs suck somewhat.

This is why I want to move to using detached-data PKCS#7 certs as the
signature.  We have the PKCS#7 handling in the kernel now for doing kexec.

David
