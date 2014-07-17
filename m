Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaGQT4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbaGQT4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:56:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <acdd27e3b559b0c1bc57a9393e4e5540a90bab36.1405094060.git.d.kasatkin@samsung.com>
References: <acdd27e3b559b0c1bc57a9393e4e5540a90bab36.1405094060.git.d.kasatkin@samsung.com> <cover.1405094060.git.d.kasatkin@samsung.com> <cover.1405094060.git.d.kasatkin@samsung.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Subject: Making the asymmetric keys config option into a top-level option
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13160.1405626953.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Jul 2014 20:55:53 +0100
Message-ID: <13161.1405626953@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> When ASYMMETRIC_KEYS=y, but depends on CRYPTO=m, selections will be also modules.
> In random config case OID_REGISTRY, MPILIB and ASN1 became modules producing build
> break. This patch removes asymmetric keys dependency from CRYPTO, but instead
> selects CRYPTO and CRYPTO_HASH as they are needed.

You do realise that this makes the asymmetric key config option into a
top-level option?  I think, logically, that's the wrong thing to do.  They
should still appear under the crypto menu.

Note that I think your patch is really the wrong solution.  The right solution
is to fix the configuration tools - but that's quite an undertaking.

David
