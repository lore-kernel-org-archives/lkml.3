Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaFMPrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:47:32 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:52418 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbaFMPra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:47:30 -0400
Date: Fri, 13 Jun 2014 10:47:27 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: David Rientjes <rientjes@google.com>
cc: Luiz Capitulino <lcapitulino@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86: numa: drop ZONE_ALIGN
In-Reply-To: <alpine.DEB.2.02.1406111553430.27885@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.10.1406131045340.913@gentwo.org>
References: <20140608181436.17de69ac@redhat.com> <CAE9FiQXpUbAOinEK-1PSFyGKqpC_FHN0sjP0xvD0ChrXR5GdAw@mail.gmail.com> <20140609150353.75eff02b@redhat.com> <CAE9FiQUWZxvCS82cH=n-NF+nhTQ83J+7M3gHdXGu2S1Qk3xL_g@mail.gmail.com> <20140611092337.35794bc0@redhat.com>
 <alpine.DEB.2.10.1406110852280.7977@gentwo.org> <alpine.DEB.2.02.1406111553430.27885@chino.kir.corp.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, David Rientjes wrote:

> > > Yes, but the question is: why?
> >
> > zones need to be aligned so that the huge pages order and other page
> > orders allocated from the page allocator are at their "natural alignment".
> > Otherwise huge pages cannot be mapped properly and various I/O devices
> > may encounter issues if they rely on the natural alignment.
> >
>
> Any reason not to align to HUGETLB_PAGE_ORDER on x86 instead of
> ZONE_ALIGN?

if MAX_ORDER = Hugetlb order then no issue.

However, if there are devices that require larger order pages (dont know
if such devices exist) then there may be an issue. SGI UV DMA engine,
graphics or some other device?


