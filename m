Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaAPMoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:44:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaAPMog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:44:36 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1389846443-21270-1-git-send-email-jlee@suse.com>
References: <1389846443-21270-1-git-send-email-jlee@suse.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Chun-Yi Lee <jlee@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Marek <mmarek@suse.com>
Subject: Re: [RESEND PATCH v3] MODSIGN: Fix including certificate twice when the signing_key.x509 already exists
Date: Thu, 16 Jan 2014 12:43:13 +0000
Message-ID: <11047.1389876193@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:

> +ifneq ($(realpath .), $(realpath $(srctree)))
> +X509_CERTIFICATES-y += $(wildcard $(srctree)/*.x509)
> +endif

This ought to be unnecessary, given the $(sort ...) here:

>  X509_CERTIFICATES-raw := $(sort $(foreach CERT,$(X509_CERTIFICATES-y), \
>  				$(or $(realpath $(CERT)),$(CERT))))

as that is supposed to remove duplicates.

However, I will admit there's a snag with my idea: $(realpath ...) doesn't
work if the argument path does not exist (hence the $(or ...)).

David
