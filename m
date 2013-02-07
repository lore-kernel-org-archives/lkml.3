Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005Ab3BGT0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:26:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50833 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806Ab3BGT0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:26:33 -0500
Message-ID: <5113FFCA.6040108@zytor.com>
Date: Thu, 07 Feb 2013 11:26:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH] x86: do not leak kernel page mapping locations
References: <20130207174413.GA12485@www.outflux.net>
In-Reply-To: <20130207174413.GA12485@www.outflux.net>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 09:44 AM, Kees Cook wrote:
> Without this patch, it is trivial to determine kernel page mappings by
> examining the error code reported to dmesg[1]. Instead, declare the entire
> kernel memory space as a violation of a present page.
> 
> Additionally, since show_unhandled_signals is enabled by default, switch
> branch hinting to the more realistic expectation, and unobfuscate the
> setting of the PF_PROT bit to improve readability.
> 
> [1] http://vulnfactory.org/blog/2013/02/06/a-linux-memory-trick/
> 
> Reported-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> Suggested-by: Brad Spengler <spender@grsecurity.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

There is, of course, tons of information in dmesg which can be used for
nefarious purposes, and it is hard to avoid that without neutering dmesg
to uselessness.

So the question is to some degree how much this adds in isolation from
locking down dmesg (and if dmesg_restrict isn't enough, what more do we
need...)?

That being said, the patch doesn't seem to do any harm so I acked it and
Ingo is going to apply it.

	-hpa



