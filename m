Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaF0NYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:24:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaF0NYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:24:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1403620852-16476-2-git-send-email-zohar@linux.vnet.ibm.com>
References: <1403620852-16476-2-git-send-email-zohar@linux.vnet.ibm.com> <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH v6 1/6] KEYS: special dot prefixed keyring name bug fix
Date: Fri, 27 Jun 2014 14:24:20 +0100
Message-ID: <7422.1403875460@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Dot prefixed keyring names are supposed to be reserved for the
> kernel, but add_key() calls key_get_type_from_user(), which
> incorrectly verifies the 'type' field, not the 'description' field.
> This patch verifies the 'description' field isn't dot prefixed,
> when creating a new keyring, and removes the dot prefix test in
> key_get_type_from_user().
> 
> Changelog v6:
> - whitespace and other cleanup
> 
> Changelog v5:
> - Only prevent userspace from creating a dot prefixed keyring, not
>   regular keys  - Dmitry
> 
> Reported-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

Acked-by: David Howells <dhowells@redhat.com>
