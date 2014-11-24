Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaKXMwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:52:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbaKXMwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:52:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5472F806.8000403@samsung.com>
References: <5472F806.8000403@samsung.com> <20141120165351.5264.61930.stgit@warthog.procyon.org.uk> <546F3742.9010702@samsung.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, mmarek@suse.cz, rusty@rustcorp.com.au,
        vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] MODSIGN: Use PKCS#7 for module signatures
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14275.1416833541.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Nov 2014 12:52:21 +0000
Message-ID: <14276.1416833541@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> Actually after cleaning the tree and re-signing the modules, I get following
> 
> Unrecognized character \x7F; marked by <-- HERE after <-- HERE near
> column 1 at ./scripts/sign-file line 1.
> make[1]: *** [arch/x86/crypto/aes-x86_64.ko] Error 255

warthog>grep -r sign-file Makefile 
mod_sign_cmd = perl $(srctree)/scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)

Because of that.  I need to remove the 'perl' bit.

David
