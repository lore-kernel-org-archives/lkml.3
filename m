Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaBNRa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:30:58 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:55084 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaBNRa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:30:56 -0500
Date: Fri, 14 Feb 2014 09:30:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: Memory allocator semantics
Message-ID: <20140214173038.GR4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140102203320.GA27615@linux.vnet.ibm.com>
 <52F60699.8010204@iki.fi>
 <20140209020004.GY4250@linux.vnet.ibm.com>
 <CAOJsxLHs890eypzfnNj4ff1zqy_=bC8FA7B0YYbcZQF_c_wSog@mail.gmail.com>
 <alpine.DEB.2.10.1402111242380.28186@nuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402111242380.28186@nuc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021417-7164-0000-0000-00000608205D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 12:43:35PM -0600, Christoph Lameter wrote:
> On Tue, 11 Feb 2014, Pekka Enberg wrote:
> 
> > So again, there's nothing in (A) that the memory allocator is
> > concerned about.  kmalloc() makes no guarantees whatsoever about the
> > visibility of "r1" across CPUs.  If you're saying that there's an
> > implicit barrier between kmalloc() and kfree(), that's an unintended
> > side-effect, not a design decision AFAICT.
> 
> I am not sure that this side effect necessarily happens. The SLUB fastpath
> does not disable interrupts and only uses a cmpxchg without lock
> semantics.

That tells me what I need to know.  Users should definitely not try a
"drive-by kfree()" of something that was concurrently allocated.  ;-)

							Thanx, Paul

