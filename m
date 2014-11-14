Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973AbaKNC07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:26:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:31764 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964876AbaKNC06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:26:58 -0500
Date: Thu, 13 Nov 2014 21:26:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH RESEND 3.18-rc3 v2 1/2] trace: kdb: Fix kernel panic
 during ftdump
Message-ID: <20141113212646.6d720886@gandalf.local.home>
In-Reply-To: <1415277716-19419-2-git-send-email-daniel.thompson@linaro.org>
References: <1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>
	<1415277716-19419-1-git-send-email-daniel.thompson@linaro.org>
	<1415277716-19419-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Nov 2014 12:41:55 +0000
Daniel Thompson <daniel.thompson@linaro.org> wrote:

> Currently kdb's ftdump command unconditionally crashes due to a null
> pointer de-reference whenever the command is run. This in turn causes
> the kernel to panic.
> 
> The abridged stacktrace (gathered with ARCH=arm) is:
> --- cut here ---

This is a nasty line. "git am " truncated the change log there thinking
it was the end of the change log (that '---' did it).

-- Steve

> [<c09535ac>] (panic) from [<c02132dc>] (die+0x264/0x440)
> [<c02132dc>] (die) from [<c0952eb8>]
> (__do_kernel_fault.part.11+0x74/0x84)
> [<c0952eb8>] (__do_kernel_fault.part.11) from [<c021f954>]
> (do_page_fault+0x1d0/0x3c4)
