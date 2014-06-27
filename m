Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaF0Ni2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:38:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaF0Ni0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:38:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1403620852-16476-4-git-send-email-zohar@linux.vnet.ibm.com>
References: <1403620852-16476-4-git-send-email-zohar@linux.vnet.ibm.com> <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH v6 3/6] KEYS: make partial key id matching as a dedicated function
Date: Fri, 27 Jun 2014 14:38:07 +0100
Message-ID: <7564.1403876287@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +	if (strncmp(id, "id:", 3) == 0)

Use memcmp() here.

> -	kid += kidlen - idlen;
> -	if (strcasecmp(id, kid) != 0)
> -		return 0;

This test is no longer applied in the "<subtype>:..." case.

David
