Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaFXSYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:24:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbaFXSX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:23:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] aio: fix kernel memory disclosure in io_getevents() introduced in v3.10
References: <cover.1403632276.git.bcrl@kvack.org>
	<edfbbf388f293d70bf4b7c0bc38774d05e6f711a.1403632276.git.bcrl@kvack.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 24 Jun 2014 14:23:20 -0400
In-Reply-To: <edfbbf388f293d70bf4b7c0bc38774d05e6f711a.1403632276.git.bcrl@kvack.org>
	(Benjamin LaHaise's message of "Tue, 24 Jun 2014 14:02:17 -0400")
Message-ID: <x4961jqb207.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise <bcrl@kvack.org> writes:

> A kernel memory disclosure was introduced in aio_read_events_ring() in v3.10
> by commit a31ad380bed817aa25f8830ad23e1a0480fef797.  The changes made to
> aio_read_events_ring() failed to correctly limit the index into
> ctx->ring_pages[], allowing an attacked to cause the subsequent kmap() of
> an arbitrary page with a copy_to_user() to copy the contents into userspace.
> This vulnerability has been assigned CVE-2014-0206.  Thanks to Mateusz and
> Petr for disclosing this issue.
>
> This patch applies to v3.12+.  A separate backport is needed for 3.10/3.11.

Note that a 3.10 backport will need to remove this line from free_ioctx
as well:
                atomic_sub(avail, &ctx->reqs_active);

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
