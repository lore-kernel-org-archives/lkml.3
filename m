Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab3LFK47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 05:56:59 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141Ab3LFK44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 05:56:56 -0500
Date: Fri, 6 Dec 2013 02:56:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, Robert Richter <rric@kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        David Daney <david.daney@cavium.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: smp_call_function_single with wait=0 considered harmful
Message-ID: <20131206105639.GA20448@infradead.org>
References: <20131204164627.GA27677@infradead.org>
 <CAErSpo49VvgpoRpS2+KHJe=zWhzR6sXdcrGdYQ5MGemi3m_Xuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo49VvgpoRpS2+KHJe=zWhzR6sXdcrGdYQ5MGemi3m_Xuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 02:43:03PM -0700, Bjorn Helgaas wrote:
> smp_call_function_single() sets "csd = &__get_cpu_var(csd_data)", so
> it's not using a struct on the stack.  We'll queue up "func" and
> likely will return before it is executed, but that should be fine
> because nobody will overwrite csd_data until it *is* executed and
> csd_unlock() has been called.

You're right, I missed the usage of the per-cpu data later in the
function.

