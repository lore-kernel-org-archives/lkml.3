Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaBKSn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:43:57 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:57138 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656AbaBKSni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:43:38 -0500
Date: Tue, 11 Feb 2014 12:43:35 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Pekka Enberg <penberg@kernel.org>
cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: Memory allocator semantics
In-Reply-To: <CAOJsxLHs890eypzfnNj4ff1zqy_=bC8FA7B0YYbcZQF_c_wSog@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1402111242380.28186@nuc>
References: <20140102203320.GA27615@linux.vnet.ibm.com> <52F60699.8010204@iki.fi> <20140209020004.GY4250@linux.vnet.ibm.com> <CAOJsxLHs890eypzfnNj4ff1zqy_=bC8FA7B0YYbcZQF_c_wSog@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Pekka Enberg wrote:

> So again, there's nothing in (A) that the memory allocator is
> concerned about.  kmalloc() makes no guarantees whatsoever about the
> visibility of "r1" across CPUs.  If you're saying that there's an
> implicit barrier between kmalloc() and kfree(), that's an unintended
> side-effect, not a design decision AFAICT.

I am not sure that this side effect necessarily happens. The SLUB fastpath
does not disable interrupts and only uses a cmpxchg without lock
semantics.

