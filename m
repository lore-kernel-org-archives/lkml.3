Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218Ab3CZUSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:18:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3CZUSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:18:30 -0400
Date: Tue, 26 Mar 2013 13:18:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, arnd@arndb.de, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UAPI: Remove empty Kbuild files
Message-Id: <20130326131828.209aff73e38d3273d078bb2e@linux-foundation.org>
In-Reply-To: <20130326174853.10144.36253.stgit@warthog.procyon.org.uk>
References: <20130326174853.10144.36253.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013 17:48:53 +0000 David Howells <dhowells@redhat.com> wrote:

> Remove empty Kbuild files as they cause problems with the patch program which
> removes files that become empty.
> 
> Should I also remove include/Kbuild as that now does nothing?  Or should it be
> left as an anchor just in case we want it in future?

I think that if the build system created it, a `make clean' or `make
mproper' should rub it out again.  Ideally a `make mrproper' will give
you a tree which is identical to a freshly-untarred kernel.org tarball
(yes?).

Which reminds me of my email which you're still hiding from ;)
Shouldn't a `make mrproper' undo the effects of `make headers_install'
by wiping ./usr/include/?

