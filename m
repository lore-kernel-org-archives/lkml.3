Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaJFNwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:52:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbaJFNwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:52:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <c7fc6e50a7854d537eef85ede24ba0792212ce59.1412327306.git.d.kasatkin@samsung.com>
References: <c7fc6e50a7854d537eef85ede24ba0792212ce59.1412327306.git.d.kasatkin@samsung.com> <cover.1412327306.git.d.kasatkin@samsung.com> <cover.1412327306.git.d.kasatkin@samsung.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        rusty@rustcorp.com.au, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 2/4] KEYS: provide pure subject key identifier (fingerprint) as key id
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9176.1412603503.1@warthog.procyon.org.uk>
Date: Mon, 06 Oct 2014 14:51:43 +0100
Message-ID: <9177.1412603503@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> -	memcpy(kid->data + len_1, val_2, len_2);
> +	if (val_2)
> +		memcpy(kid->data + len_1, val_2, len_2);

Btw, I think this should probably be "if (len_2)" rather than "if (val_2)" so
that we don't bother with the memcpy() if there's no second component.

David
