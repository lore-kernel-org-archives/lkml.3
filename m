Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab3LLTcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:32:25 -0500
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:49565 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162Ab3LLTcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:32:24 -0500
Date: Thu, 12 Dec 2013 19:32:22 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Hansen <dave@sr71.net>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC][PATCH 1/3] mm: slab: create helpers for slab ->freelist
 pointer
In-Reply-To: <20131211224023.5F39AC88@viggo.jf.intel.com>
Message-ID: <00000142e84bacf0-e6eeb332-e66b-48c6-95d8-d4a7cba0f24d-000000@email.amazonses.com>
References: <20131211224022.AA8CF0B9@viggo.jf.intel.com> <20131211224023.5F39AC88@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.12-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Dave Hansen wrote:

>
> We have a need to move the ->freelist data around 'struct page'
> in order to keep a cmpxchg aligned.  First step is to add an
> accessor function which we will hook in to in the next patch.
>
> I'm not super-happy with how this looks.  It's a bit ugly, but it
> does work.  I'm open to some better suggestions for how to do
> this.


I think the mapping field is not used by SLUB and its ok to use since SLAB
uses it for its memory pointer. Maybe you can use that to get the correct
alignment? Do an and of address used for the cmpxchg with 0xffff
.. ff0 to ensure proper aligment (the resulting address may overlap
the mapping field).

