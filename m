Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3KUMt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:49:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:44637 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751491Ab3KUMt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:49:28 -0500
Date: Thu, 21 Nov 2013 07:49:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall
Message-ID: <20131121124926.GB8044@home.goodmis.org>
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
 <528AF5D7.7000308@zytor.com>
 <20131119184959.GE29695@two.firstfloor.org>
 <528CE65B.6020300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528CE65B.6020300@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 08:42:03AM -0800, H. Peter Anvin wrote:
> We're talking user space here, which has different requirement (COW,
> memory protection, ...) which means it is not really the same code.  You
> can't take a page fault while patching the kernel.

Well, technically you can take a page fault while patching the kernel. It
happens all the time when patching modules (vmalloc'd).

But I get your point. You don't have to worry about COW or being paged
out. "page fault" is just too general of a term. And yes, I'm being anal ;-)

-- Steve

