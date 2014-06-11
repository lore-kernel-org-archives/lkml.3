Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaFKWyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:54:08 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:53830 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbaFKWyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:54:06 -0400
Date: Wed, 11 Jun 2014 15:54:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@gentwo.org>
cc: Luiz Capitulino <lcapitulino@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86: numa: drop ZONE_ALIGN
In-Reply-To: <alpine.DEB.2.10.1406110852280.7977@gentwo.org>
Message-ID: <alpine.DEB.2.02.1406111553430.27885@chino.kir.corp.google.com>
References: <20140608181436.17de69ac@redhat.com> <CAE9FiQXpUbAOinEK-1PSFyGKqpC_FHN0sjP0xvD0ChrXR5GdAw@mail.gmail.com> <20140609150353.75eff02b@redhat.com> <CAE9FiQUWZxvCS82cH=n-NF+nhTQ83J+7M3gHdXGu2S1Qk3xL_g@mail.gmail.com> <20140611092337.35794bc0@redhat.com>
 <alpine.DEB.2.10.1406110852280.7977@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Christoph Lameter wrote:

> > > The zone should not cross the 8M boundary?
> >
> > Yes, but the question is: why?
> 
> zones need to be aligned so that the huge pages order and other page
> orders allocated from the page allocator are at their "natural alignment".
> Otherwise huge pages cannot be mapped properly and various I/O devices
> may encounter issues if they rely on the natural alignment.
> 

Any reason not to align to HUGETLB_PAGE_ORDER on x86 instead of 
ZONE_ALIGN?
