Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaEOLSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 07:18:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaEOLSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 07:18:16 -0400
Date: Thu, 15 May 2014 04:18:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Message-ID: <20140515111800.GA29456@infradead.org>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
 <8399002.IIyBoyEHox@wuerfel>
 <CANcMJZAOi9ctWkpEgynj6wxCrvW4oS5ZHj3Chv04D=VQDogEvw@mail.gmail.com>
 <4160991.69XaTMjMrC@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4160991.69XaTMjMrC@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 01:08:02PM +0200, Arnd Bergmann wrote:
> c) glibc may or may not provide a way for applications to use
>    the extended interfaces without a user space ABI break. My
>    impression so far is that this is going to be too hard and
>    it won't be done, but this is for the glibc developers to
>    determine.
>
> The important distinction here is between user space time_t
> (timeval, timespec) and __kernel_time_t. We probably need
> to make the user space time_t a build-time conditional,
> at least for the foreseeable future. New architectures or
> new C libraries can start out using 64-bit time_t unconditionally.

I don't think there is any point in introducing new kernel interfaces
without having a talk to the glibc folks and people that represent the
Linux community in the standard body (e.g. Eric Blake).

How about you start sending a first high-level proposal with libc-alpha,
linux-kernel, linux-api and Eric in the Cc list and we'll see how we
can come up with something that is actually usable to solve our users
Y2038 problem.  Without coordination we're just handing on the hot
potato.

