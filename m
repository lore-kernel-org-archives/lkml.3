Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaFWT5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:57:25 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53814 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWT5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:57:24 -0400
From: Andy Lutomirski <luto@amacapital.net>
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <53A886A0.1010508@mit.edu>
Date: Mon, 23 Jun 2014 12:57:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 09/10] x86, mpx: cleanup unused bound tables
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-10-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1403084656-27284-10-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 02:44 AM, Qiaowei Ren wrote:
> When user memory region is unmapped, related bound tables
> become unused and need to be released also. This patch cleanups
> these unused bound tables through hooking unmap path.

This is not a full review at all -- I don't understand the mm stuff well
enough.

> +
> +	/*
> +	 * If this bounds directory entry is nonzero, and meanwhile
> +	 * the valid bit is zero, one SIGSEGV will be produced due to
> +	 * this unexpected situation.
> +	 */
> +	if (!(*valid) && *bt_addr)
> +		force_sig(SIGSEGV, current);

force_sig from a syscall handler seems rather weird.

