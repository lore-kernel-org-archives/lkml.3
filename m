Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab3FYHba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:31:30 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:52955 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3FYHb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:31:28 -0400
Date: Tue, 25 Jun 2013 09:31:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, holt@sgi.com, travis@sgi.com,
        rob@landley.net, tglx@linutronix.de, mingo@redhat.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 2/2] x86_64, mm: Reinsert the absent memory
Message-ID: <20130625073122.GB11420@gmail.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
 <1371831934-156971-3-git-send-email-nzimmer@sgi.com>
 <20130623092840.GB13445@gmail.com>
 <20130623093250.GA13776@gmail.com>
 <51C88400.7090907@zytor.com>
 <20130624193959.GB4065@gmail.com>
 <51C8A728.8010409@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C8A728.8010409@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 06/24/2013 12:39 PM, Ingo Molnar wrote:
> > 
> > That might be a bit too granular: if we hit such an uninitialized block of 
> > memory we'd have to process 262,144 pages - potentially from an IRQ 
> > handler that does GFP_ATOMIC... or other latency critical code.
> > 
> > With 2MB we'd have to on-demand initialize 512 pages, which shouldn't show 
> > up during normal use.
> > 
> 
> No... you split the gigabyte page into 511 2M pages and 512 4K pages.

Oh, double deferred initialization. That should solve the 32 exabyte 
problem as well I guess ;-)

Thanks,

	Ingo
