Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3KIGqO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:46:14 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37653 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3KIGqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:46:12 -0500
MIME-Version: 1.0
In-Reply-To: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org>
References: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org>
Date: Sat, 9 Nov 2013 00:46:11 -0600
Message-ID: <CAHCPf3tCTUEX6oDLUndZwt=Hk+YxsKjPO96N=Zhx82+_LM66sQ@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
From: Matt Sealey <neko@bakuhatsu.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Christopher Covington <cov@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Rob Herring <robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 8, 2013 at 5:00 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> If we're running on a v7 ARM CPU, detect if the CPU supports the
> sdiv/udiv instructions and replace the signed and unsigned
> division library functions with an sdiv/udiv instruction.
>
> Running the perf messaging benchmark in pipe mode
>
>  $ perf bench sched messaging -p
>
> shows a modest improvement on my v7 CPU.
>
> before:
> (5.060 + 5.960 + 5.971 + 5.643 + 6.029 + 5.665 + 6.050 + 5.870 + 6.117 + 5.683) / 10 = 5.805
>
> after:
> (4.884 + 5.549 + 5.749 + 6.001 + 5.460 + 5.103 + 5.956 + 6.112 + 5.468 + 5.093) / 10 = 5.538
>
> (5.805 - 5.538) / 5.805 = 4.6%

Even with the change to the output constraint suggested by Mans, you
get absolutely identical benchmark results? There's a lot of variance
in any case..

BTW has there been any evaluation of the penalty for the extra
branching, or the performance hit for the ARMv7-without-division
cases?

Ta,
Matt Sealey <neko@bakuhatsu.net>
