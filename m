Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab3ASBCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:02:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab3ASBCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:02:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1358556813-12518-1-git-send-email-dinggnu@gmail.com>
References: <1358556813-12518-1-git-send-email-dinggnu@gmail.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/keys/system_keyring.h: fix building error
Date: Sat, 19 Jan 2013 01:02:46 +0000
Message-ID: <8083.1358557366@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Ding <dinggnu@gmail.com> wrote:

> When I am doing "make randconfig", it causes the following building error if
> CONFIG_SYSTEM_TRUSTED_KEYRING is not defined and CONFIG_MODULE_SIG is defined.

Can you tell me what you're doing your build upon?

> -#ifdef CONFIG_SYSTEM_TRUSTED_KEYRING
> +#if defined(CONFIG_SYSTEM_TRUSTED_KEYRING) || defined(CONFIG_MODULE_SIG)

This isn't the right way to do it: CONFIG_MODULE_SIG should require
CONFIG_SYSTEM_TRUSTED_KEYRING to be "=y" otherwise you don't get the .c file
either.  Can you check that it isn't "=m"?

David
