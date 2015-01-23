Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbbAWM4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:56:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbbAWM4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:56:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <54C23FE2.9030303@ahsoftware.de>
References: <54C23FE2.9030303@ahsoftware.de> <1421976009-9819-1-git-send-email-holler@ahsoftware.de> <54C21361.1080500@suse.cz> <54C216D8.8040004@ahsoftware.de> <54C21F35.1040206@ahsoftware.de> <54C22891.6070506@suse.cz> <54C233FB.3080309@ahsoftware.de> <54C2367C.4000909@ahsoftware.de>
To: Alexander Holler <holler@ahsoftware.de>
Cc: dhowells@redhat.com, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] modsign: provide option to automatically delete the key after modules were installed
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27400.1422017769.1@warthog.procyon.org.uk>
Date: Fri, 23 Jan 2015 12:56:09 +0000
Message-ID: <27402.1422017769@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Holler <holler@ahsoftware.de> wrote:

> 1. I have no idea about how distro maintainers do handle their private and
> public keys used to sign modules.

In Fedora and RHEL, at least, we use a one-off on-the-fly generated transient
key for each rpm build.

When a kernel is built by rpmbuild, the source directory is generated afresh
and a new key created each time.  In the build farms, the kernel build tree is
simply erased, private key and all, at the conclusion of the build.

We make no effort to retain the transient private key as (1) it would require
special handling for kernel builds to avoid leaking it, (2) it might impact
non-buildfarm builds, and (3) it's more secure that no one has the private
key.

One thing that you have to be careful of with your patch is that if you turn
it on during development, this will drain the entropy pool from which you get
random numbers.

David
