Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965229Ab3GLSWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 14:22:22 -0400
Received: from www.sr71.net ([198.145.64.142]:47412 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933256Ab3GLSWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 14:22:21 -0400
Message-ID: <51E04957.3080601@sr71.net>
Date: Fri, 12 Jul 2013 11:22:15 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Dave Jones <davej@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Yet more softlockups.
References: <20130706072408.GA14865@gmail.com> <20130710151324.GA11309@redhat.com> <20130710152015.GA757@x4> <20130710154029.GB11309@redhat.com> <20130712103117.GA14862@gmail.com> <51E0230C.9010509@intel.com> <20130712154521.GD1020@redhat.com> <51E038ED.7050600@gmail.com> <20130712171808.GD1537@redhat.com> <51E03F76.3090607@gmail.com> <20130712175028.GA11036@redhat.com> <51E045E0.8020702@gmail.com>
In-Reply-To: <51E045E0.8020702@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 11:07 AM, David Ahern wrote:
> And Dave Hansen: I think nmi.c has the same do_div problem as
> kernel/events/core.c that Stephane fixed. Your patch has:
> 
>         whole_msecs = do_div(delta, (1000 * 1000));
>         decimal_msecs = do_div(delta, 1000) % 1000;

Yup.  There should be fixes in the x86 tip tree for both of these now.
