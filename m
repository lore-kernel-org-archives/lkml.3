Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbaKAT4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 15:56:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:47403 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469AbaKAT4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 15:56:16 -0400
Date: Sat, 1 Nov 2014 20:56:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        x86@kernel.org
Subject: Re: [PATCH v2 2/8] x86: Clean up cr4 manipulation
In-Reply-To: <495a10bdc9e67016b8fd3945700d46cfd5c12c2f.1414190806.git.luto@amacapital.net>
Message-ID: <alpine.DEB.2.11.1411012055240.5308@nanos>
References: <cover.1414190806.git.luto@amacapital.net> <495a10bdc9e67016b8fd3945700d46cfd5c12c2f.1414190806.git.luto@amacapital.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Andy Lutomirski wrote:

> CR4 manipulation was split, seemingly at random, between direct
> (write_cr4) and using a helper (set/clear_in_cr4).  Unfortunately,
> the set_in_cr4 and clear_in_cr4 helpers also poke at the boot code,
> which only a small subset of users actually wanted.
> 
> This patch replaces all cr4 access in functions that don't leave cr4
> exactly the way they found it with new helpers cr4_set_bits,
> cr4_clear_bits, and cr4_set_bits_and_update_boot.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

