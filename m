Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaJPIQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:16:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36773 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaJPIQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:16:44 -0400
Date: Thu, 16 Oct 2014 10:16:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 1/5] x86: Clean up cr4 manipulation
Message-ID: <20141016081633.GG7369@worktop.fdxtended.com>
References: <cover.1413323611.git.luto@amacapital.net>
 <724658a527c0572dde1a400a5e90b85f45421201.1413323611.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <724658a527c0572dde1a400a5e90b85f45421201.1413323611.git.luto@amacapital.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 03:57:35PM -0700, Andy Lutomirski wrote:
> +/* Set in this cpu's CR4. */
> +static inline void cr4_set(unsigned long mask)
> +{
> +	unsigned long cr4;
> +
> +	cr4 = read_cr4();
> +	cr4 |= mask;
> +	write_cr4(cr4);
> +}
> +
> +/* Clear in this cpu's CR4. */
> +static inline void cr4_clear(unsigned long mask)
> +{
> +	unsigned long cr4;
> +
> +	cr4 = read_cr4();
> +	cr4 &= ~mask;
> +	write_cr4(cr4);
> +}

I would have called these cr4_or() and cr4_nand(). When first reading
this I expected cr4_set() to be a pure write_cr4() and cr4_clear() to do
write_cr4(0) -- which obviously doesn't make too much sense.


cr4_{set,clear}_mask() might maybe be clearer but is more typing, and
the logical ops as suggested should have unambiguous meaning.
