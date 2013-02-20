Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3BTV6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:58:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3BTV6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:58:31 -0500
Date: Wed, 20 Feb 2013 13:58:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, jkosina@suse.cz, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Revert one application of "Fix unreachable code"
 patch
Message-Id: <20130220135830.1a290e0f.akpm@linux-foundation.org>
In-Reply-To: <20130220122431.1410.12819.stgit@warthog.procyon.org.uk>
References: <20130220122431.1410.12819.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013 12:24:32 +0000
David Howells <dhowells@redhat.com> wrote:

> A patch to fix some unreachable code in search_my_process_keyrings() got
> applied twice by two different routes upstream:
> 
> 	commit e67eab39bee26f509d38d00ca1a8f24b63f46a31
> 	Author: Alan Cox <alan@linux.intel.com>
> 	Date:   Thu Dec 20 15:05:54 2012 -0800
> 	keys: fix unreachable code
> 
> and:
> 
> 	commit b010520ab3d2c05eb444ed5e01fe6c33842f597a
> 	Author: Alan Cox <alan@linux.intel.com>
> 	Date:   Thu Oct 25 15:23:35 2012 +0100
> 	keys: Fix unreachable code
> 
> Unfortunately, the second application removed something it shouldn't have and
> this wasn't detected by GIT.  This is due to the patch not having sufficient
> lines of context to distinguish the two places of application.
> 
> So revert the second application of the patch.

The runtime effects of this aren't described, so I don't know whether
the omission of cc:stable was deliberate :(
