Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3LSAry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:47:54 -0500
Received: from www.sr71.net ([198.145.64.142]:33801 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab3LSArx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:47:53 -0500
Message-ID: <52B2424F.7050406@sr71.net>
Date: Wed, 18 Dec 2013 16:48:15 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pravin B Shelar <pshelar@nicira.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC][PATCH 0/7] re-shrink 'struct page' when SLUB is on.
References: <20131213235903.8236C539@viggo.jf.intel.com>	<20131216160128.aa1f1eb8039f5eee578cf560@linux-foundation.org>	<52AF9EB9.7080606@sr71.net>	<0000014301223b3e-a73f3d59-8234-48f1-9888-9af32709a879-000000@email.amazonses.com>	<52B23CAF.809@sr71.net> <20131218164109.5e169e258378fac44ec5212d@linux-foundation.org>
In-Reply-To: <20131218164109.5e169e258378fac44ec5212d@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 04:41 PM, Andrew Morton wrote:
>> > Unless somebody can find some holes in this, I think we have no choice
>> > but to unset the HAVE_ALIGNED_STRUCT_PAGE config option and revert using
>> > the cmpxchg, at least for now.
>
> So your scary patch series which shrinks struct page while retaining
> the cmpxchg_double() might reclaim most of this loss?

That's what I'll test next, but I hope so.

The config tweak is important because it shows a low-risk way to get a
small 'struct page', plus get back some performance that we lost and
evidently never noticed.  A distro that was nearing a release might want
to go with this, for instance.
