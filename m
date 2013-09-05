Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3IETuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:50:44 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:64799 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3IETun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:50:43 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CDCCFA@ORSMSX106.amr.corp.intel.com>
References: <20130905131814.GA24274@osiris>
	<CA+55aFyZ8xLWiPcP3jcnVApQOqAvpo_fshSvGpdpW42iRutPcQ@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDC7F7@ORSMSX106.amr.corp.intel.com>
	<CA+55aFyevZQG5pEz-iJF6MFEMpwJD=biB-x852ki0spOM293Sg@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDCC23@ORSMSX106.amr.corp.intel.com>
	<CA+55aFw_Rovv7YTb62q5NQvucM5ks8+HXcsTOJ-oJ+kqmHop4A@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDCCFA@ORSMSX106.amr.corp.intel.com>
Date: Thu, 5 Sep 2013 12:50:42 -0700
X-Google-Sender-Auth: nQNC9ltervEZaZ2i2FdOBLyNCc0
Message-ID: <CA+55aFy0BZ8kL0TMgV+u1g5Rt=hBJw44+kps5RzD-s=Uo-zsLg@mail.gmail.com>
Subject: Re: [PATCH] lockref: remove cpu_relax() again
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 12:45 PM, Luck, Tony <tony.luck@intel.com> wrote:
>
> No.  I can change the Linux code to say "cmpxchg.rel" here ... but the
> h/w will do exactly the same thing it did when I had "cmpxchg.acq".

Oh, so when you said "So we had to back-pedal and keep the "legacy"
behavior of a full fence", you meant the hardware design itself, not
(as I assumed) the Linux kernel header behavior.

Oh well. Hopefully somebody in hardware learnt how stupid it is to
expose weak memory ordering to software. But probably not.

Ugh. Your four-socket machine certainly should have been able to see
the performance improvements of not spinning.

That said, another thing that strikes me is that you have 32 CPU
threads, and the stupid test-program I sent out had MAX_THREADS set to
16.  Did you change that? Becuase if not, then some of the extreme
performance profile might be about how the threads get scheduled on
your machine (HT threads vs full cores etc).

                Linus
