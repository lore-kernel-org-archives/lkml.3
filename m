Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3LJVY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:24:29 -0500
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:35378 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000Ab3LJVY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:24:27 -0500
X-Greylist: delayed 1005 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Dec 2013 16:24:27 EST
Date: Tue, 10 Dec 2013 21:07:40 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Hansen <dave@sr71.net>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] mm: slab: separate slab_page from 'struct page'
In-Reply-To: <20131210204641.3CB515AE@viggo.jf.intel.com>
Message-ID: <00000142de5634af-f92870a7-efe2-45cd-b50d-a6fbdf3b353c-000000@email.amazonses.com>
References: <20131210204641.3CB515AE@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.10-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Dave Hansen wrote:

> At least for slab, this doesn't turn out to be too big of a deal:
> it's only 8 casts.  slub looks like it'll be a bit more work, but
> still manageable.

The single page struct definitions makes it easy to see how a certain
field is being used in various subsystems. If you add a field then you
can see other use cases in other subsystems. If you happen to call
them then you know that there is trouble afoot.

Also if you screw up the sizes then you screw up the page struct for
everything and its very evident that a problem exists.

How do you ensure that the sizes and the locations of the fields in
multiple page structs stay consistent?

As far as I can tell we are trying to put everything into one page struct
to keep track of the uses of various fields and to allow a reference for
newcomes to the kernel.

