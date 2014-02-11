Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaBKMJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:09:24 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35339 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaBKMJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:09:22 -0500
Date: Tue, 11 Feb 2014 04:09:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: Memory allocator semantics
Message-ID: <20140211120915.GP4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140102203320.GA27615@linux.vnet.ibm.com>
 <52F60699.8010204@iki.fi>
 <20140209020004.GY4250@linux.vnet.ibm.com>
 <CAOJsxLHs890eypzfnNj4ff1zqy_=bC8FA7B0YYbcZQF_c_wSog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLHs890eypzfnNj4ff1zqy_=bC8FA7B0YYbcZQF_c_wSog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021112-0928-0000-0000-00000636B502
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 10:50:24AM +0200, Pekka Enberg wrote:
> Hi Paul,
> 
> On Sun, Feb 9, 2014 at 4:00 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > From what I can see, (A) works by accident, but is kind of useless because
> > you allocate and free the memory without touching it.  (B) and (C) are the
> > lightest touches I could imagine, and as you say, both are bad.  So I
> > believe that it is reasonable to prohibit (A).
> >
> > Or is there some use for (A) that I am missing?
> 
> So again, there's nothing in (A) that the memory allocator is
> concerned about.  kmalloc() makes no guarantees whatsoever about the
> visibility of "r1" across CPUs.  If you're saying that there's an
> implicit barrier between kmalloc() and kfree(), that's an unintended
> side-effect, not a design decision AFAICT.

Thank you.  That was what I suspected, and I believe that it is a
completely reasonable response to (A).

							Thanx, Paul

