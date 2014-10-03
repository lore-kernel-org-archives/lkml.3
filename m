Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaJCMVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:21:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaJCMVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:21:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CACE9dm8ZmVJe7qadrLwXEQHYrmau_Mbahnz4FSBaWD4GB==JMw@mail.gmail.com>
References: <CACE9dm8ZmVJe7qadrLwXEQHYrmau_Mbahnz4FSBaWD4GB==JMw@mail.gmail.com> <20140908153704.28301.41578.stgit@warthog.procyon.org.uk> <20140908153830.28301.37880.stgit@warthog.procyon.org.uk> <542D741D.5070109@samsung.com> <542D77A4.5030606@samsung.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: dhowells@redhat.com, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        keyrings <keyrings@linux-nfs.org>, Josh Boyer <jwboyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        pjones@redhat.com, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 08/13] KEYS: Overhaul key identification when searching for asymmetric keys
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28662.1412338855.1@warthog.procyon.org.uk>
Date: Fri, 03 Oct 2014 13:20:55 +0100
Message-ID: <28663.1412338855@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <dmitry.kasatkin@gmail.com> wrote:

> What is this 6865612e68326732?

It's the tail of the first ID attached to the key (there may be more than
one).  As this is derived from an X.509 cert, that will be the serial number
plus the ASN.1 encoded issuer name.

To quote from the description in the patch:

 (1) Use the previously created asymmetric_key_id struct to hold the following
     key IDs derived from the X.509 certificate or PKCS#7 message:

	id: serial number + issuer
	skid: subjKeyId + subject
	authority: authKeyId + issuer

 (2) Replace the hex fingerprint attached to key->type_data[1] with an
     asymmetric_key_ids struct containing the id and the skid (if present).

If you turn the hex into chars, you will see "hea.h2g2"

I'm open to suggestions about the best way to represent the auxiliary IDs in
/proc/keys - but don't forget there can be more than one.

David
