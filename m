Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaEZTh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:37:29 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45694 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaEZTh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:37:28 -0400
Message-ID: <538397F5.6010002@amacapital.net>
Date: Mon, 26 May 2014 12:37:25 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 0/15] x86/xsaves: Optimize xstate context switch by xsaves/xrstors
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 10:01 AM, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> With ever growing extended state registers (xstate) on x86 processors, kernel
> needs to cope with issue of growing memory space occupied by xstate. The xsave
> area is holding more and more xstate registers, growing from legacy FP and
> SSE to AVX, AVX2, AVX-512, MPX, and Intel PT.
> 
> The recently introduced compacted format of xsave area saves xstates only
> for enabled states. This patch set saves the xsave area space per process
> in compacted format by xsaves/xrstors instructions.

Are we going to want to encourage userspace to do something like
sticking vzeroupper right before each syscall to make any
xsaves/xrestores faster?

--Andy

