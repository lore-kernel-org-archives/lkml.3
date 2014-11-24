Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaKXMvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:51:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbaKXMvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:51:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <547325A2.7070408@samsung.com>
References: <547325A2.7070408@samsung.com> <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, mmarek@suse.cz, rusty@rustcorp.com.au,
        vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] MODSIGN: Use PKCS#7 for module signatures
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14250.1416833491.1@warthog.procyon.org.uk>
Date: Mon, 24 Nov 2014 12:51:31 +0000
Message-ID: <14251.1416833491@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> >  (2) Makes use of the PKCS#7 facility to provide module signatures.
> >
> >      sign-file is replaced with a program that generates a PKCS#7 message
> >      that has no X.509 certs embedded and that has detached data (the
> >      module content) and adds it onto the message with magic string and
> >      descriptor.
> 
> Why do you highlight that X509 is not embedded?
> Current module signing does not embed X509 also.

A PKCS#7 message can have X.509 certs embedded within it - but it's optional
within the spec.  Given that we expect to have the appropriate cert available
to verify the signature on the PKCS#7 message directly, there's no need to
actually embed the X.509 cert therein.

Unfortunately, it doesn't appear that you can do this with the openssl command
line utility - hence why I moved to C.

David
