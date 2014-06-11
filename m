Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaFKN64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:58:56 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:50022 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbaFKN6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:58:54 -0400
Date: Wed, 11 Jun 2014 08:58:51 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
cc: Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86: numa: drop ZONE_ALIGN
In-Reply-To: <20140611092337.35794bc0@redhat.com>
Message-ID: <alpine.DEB.2.10.1406110852280.7977@gentwo.org>
References: <20140608181436.17de69ac@redhat.com> <CAE9FiQXpUbAOinEK-1PSFyGKqpC_FHN0sjP0xvD0ChrXR5GdAw@mail.gmail.com> <20140609150353.75eff02b@redhat.com> <CAE9FiQUWZxvCS82cH=n-NF+nhTQ83J+7M3gHdXGu2S1Qk3xL_g@mail.gmail.com>
 <20140611092337.35794bc0@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Luiz Capitulino wrote:

> > The zone should not cross the 8M boundary?
>
> Yes, but the question is: why?

zones need to be aligned so that the huge pages order and other page
orders allocated from the page allocator are at their "natural alignment".
Otherwise huge pages cannot be mapped properly and various I/O devices
may encounter issues if they rely on the natural alignment.

> My current thinking, after discussing this with David, is to just page
> align the memory range. This should fix the hyperv-triggered bug in 2.6.32
> and seems to be the right thing for upstream too.

You need to make sure that the page orders can be allocated at their
proper boundaries.

