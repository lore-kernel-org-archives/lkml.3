Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaJCNkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:40:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbaJCNka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:40:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <542E9FE8.2070009@samsung.com>
References: <542E9FE8.2070009@samsung.com> <6d32cecfb3c3f5d041900ce1866bc15134832991.1412327306.git.d.kasatkin@samsung.com> <cover.1412327306.git.d.kasatkin@samsung.com> <cover.1412327306.git.d.kasatkin@samsung.com> <29146.1412340378@warthog.procyon.org.uk> <542E9B68.1010906@samsung.com> <542E9C65.4030208@samsung.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        rusty@rustcorp.com.au, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 3/4] module: search the key only by keyid
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13200.1412343605.1@warthog.procyon.org.uk>
Date: Fri, 03 Oct 2014 14:40:05 +0100
Message-ID: <13201.1412343605@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> BTW. But actually why signer is needed to find the key?
> Every key has unique fingerprint.

The SKID is by no means guaranteed unique, is not mandatory and has no defined
algorithm for generating it.

> Or you say that different certificates might have the same PK?
> What I would consider strange. But anyway, if PK is the same, then
> verification succeed.

Do note: We *do* need to get away from using SKIDs.  We have situations where
we have to use a key that doesn't have one.

David
