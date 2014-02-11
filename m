Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaBKIu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:50:29 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47393 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaBKIuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:50:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140209020004.GY4250@linux.vnet.ibm.com>
References: <20140102203320.GA27615@linux.vnet.ibm.com>
	<52F60699.8010204@iki.fi>
	<20140209020004.GY4250@linux.vnet.ibm.com>
Date: Tue, 11 Feb 2014 10:50:24 +0200
X-Google-Sender-Auth: ibqmimNeL75kB0ByOsTr0usXRcs
Message-ID: <CAOJsxLHs890eypzfnNj4ff1zqy_=bC8FA7B0YYbcZQF_c_wSog@mail.gmail.com>
Subject: Re: Memory allocator semantics
From: Pekka Enberg <penberg@kernel.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sun, Feb 9, 2014 at 4:00 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> From what I can see, (A) works by accident, but is kind of useless because
> you allocate and free the memory without touching it.  (B) and (C) are the
> lightest touches I could imagine, and as you say, both are bad.  So I
> believe that it is reasonable to prohibit (A).
>
> Or is there some use for (A) that I am missing?

So again, there's nothing in (A) that the memory allocator is
concerned about.  kmalloc() makes no guarantees whatsoever about the
visibility of "r1" across CPUs.  If you're saying that there's an
implicit barrier between kmalloc() and kfree(), that's an unintended
side-effect, not a design decision AFAICT.

                                 Pekka
