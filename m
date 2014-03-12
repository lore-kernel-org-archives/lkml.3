Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbaCLB6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:58:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:56153 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755888AbaCLB6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:58:47 -0400
Date: Tue, 11 Mar 2014 21:58:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0/7] arm64: Add ftrace support
Message-ID: <20140311215844.70ada249@gandalf.local.home>
In-Reply-To: <531FBCA8.2080805@linaro.org>
References: <1393320196-2942-1-git-send-email-takahiro.akashi@linaro.org>
	<1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
	<20140311143535.GE7944@mudshark.cambridge.arm.com>
	<531FBCA8.2080805@linaro.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 10:47:20 +0900
AKASHI Takahiro <takahiro.akashi@linaro.org> wrote:

> This happens when a header file, elf.h, on "your host machine" does not have
> definitions of EM_AARCH64 nor R_AARCH64_ABS64 because "recordmcount" is a binary
> utility on host(x86), not target. It is very likely for most distros.
> (I mentioned this in the cover letter, but the description might not be clear.)
> 
> Possible solutions are:
> 1) Define both macros directly in scripts/recordmcount.c
> 2) Use perl version of recordmcount
> 
> Currently I take 1), but it is a workaround.
> 2) should work with my current patch, too. But you need to remove HAVE_C_RECORDCOUNT
> from arm64/Kconfig.
> 
> Which one do you prefer? I will include a fix for 1) in the next revision, anyway.
> 

I'd recommend #1, where you add this:

/* AARCH64 is new, and most headers don't define it. */
#ifndef EM_AARCH64
#define EM_AARCH64  ##
#define R_AARCH64_ABS64 ##
#endif

Obviously fill in the blank for ##

-- Steve
