Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab3ECPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:25:28 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:56473 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932433Ab3ECPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:25:27 -0400
Date: Fri, 3 May 2013 15:25:25 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        penberg@kernel.org, rientjes@google.com, linux-mm@kvack.org
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
In-Reply-To: <20130503030345.GE4441@localhost.localdomain>
Message-ID: <0000013e6aff6f95-b8fa366e-51a5-4632-962e-1b990520f5a8-000000@email.amazonses.com>
References: <0000013e3cb0340d-00f360e3-076b-478e-b94c-ddd4476196ce-000000@email.amazonses.com> <20130425060705.GK2672@localhost.localdomain> <0000013e427023d7-9456c313-8654-420c-b85a-cb79cc3c4ffc-000000@email.amazonses.com> <20130426062436.GB4441@localhost.localdomain>
 <0000013e46cba821-d5c54c99-3b5c-4669-9a54-9fb8f4ee516f-000000@email.amazonses.com> <20130427112418.GC4441@localhost.localdomain> <0000013e5645b356-09aa6796-0a95-40f1-8ec5-6e2e3d0c434f-000000@email.amazonses.com> <20130429145711.GC1172@dhcp22.suse.cz>
 <20130502105637.GD4441@localhost.localdomain> <0000013e65cb32b3-047cd2d6-dfc8-41d2-a792-9b398f9a1baf-000000@email.amazonses.com> <20130503030345.GE4441@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.03-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 May 2013, Han Pingtian wrote:

> On Thu, May 02, 2013 at 03:10:15PM +0000, Christoph Lameter wrote:
> > On Thu, 2 May 2013, Han Pingtian wrote:
> >
> > > Looks like "ibmvscsi" + "slub" can trigger this problem.
> >
> > And the next merge of the slab-next tree will also cause SLAB to trigger
> > this issue. I would like to have this fixes. The slab allocator purpose is
> > to servr objects that are a fraction of a page and not objects that are
> > larger than the maximum allowed sizes of the page allocator.
>
> So the problem is in memory management code, not in ibmvscis? And looks
> like there is a fix already?

Both should be fixed. Making requests for large amounts of memory from an
allocator that is supposed to hand out fraction of a page does not make
sense.

