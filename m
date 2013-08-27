Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3H0Jmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:42:36 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54286 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752858Ab3H0Jmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:42:33 -0400
Date: Tue, 27 Aug 2013 10:41:43 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [guv v2 22/31] arm: Replace __get_cpu_var uses
Message-ID: <20130827094143.GC19897@arm.com>
References: <20130826204351.725357339@linux.com>
 <00000140bc5f3c35-f4075639-884b-4ae3-b7bd-d945b44d7cf5-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140bc5f3c35-f4075639-884b-4ae3-b7bd-d945b44d7cf5-000000@email.amazonses.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 09:44:52PM +0100, Christoph Lameter wrote:
> This patch converts __get_cpu_var into either and explicit address calculation using this_cpu_ptr()
> or into a use of this_cpu operations that use the offset. Thereby address calcualtions are avoided
> and less registers are used when code is generated.
...
> Index: linux/arch/arm64/kernel/debug-monitors.c
> ===================================================================
> --- linux.orig/arch/arm64/kernel/debug-monitors.c	2013-08-26 13:48:40.956794980 -0500
> +++ linux/arch/arm64/kernel/debug-monitors.c	2013-08-26 13:48:40.952795024 -0500
...
> Index: linux/arch/arm64/kernel/hw_breakpoint.c
> ===================================================================
> --- linux.orig/arch/arm64/kernel/hw_breakpoint.c	2013-08-26 13:48:40.956794980 -0500
> +++ linux/arch/arm64/kernel/hw_breakpoint.c	2013-08-26 13:48:40.952795024 -0500
...
> Index: linux/arch/arm64/kernel/perf_event.c
> ===================================================================
> --- linux.orig/arch/arm64/kernel/perf_event.c	2013-08-26 13:48:40.956794980 -0500
> +++ linux/arch/arm64/kernel/perf_event.c	2013-08-26 13:48:40.952795024 -0500

For the arm64 bits:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
