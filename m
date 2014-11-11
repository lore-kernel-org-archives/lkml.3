Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaKKTq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:46:28 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32931 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaKKTq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:46:27 -0500
Date: Tue, 11 Nov 2014 20:46:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        x86@kernel.org
Subject: Re: [PATCH 3/6] x86: Add support for the clwb instruction
Message-ID: <20141111194621.GB12555@pd.tnic>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
 <1415731396-19364-4-git-send-email-ross.zwisler@linux.intel.com>
 <20141111191239.GC31523@pd.tnic>
 <20141111191904.GA12555@pd.tnic>
 <1415734800.21508.0.camel@theros.lm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415734800.21508.0.camel@theros.lm.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 12:40:00PM -0700, Ross Zwisler wrote:
> Yep, it's weird, I know.  :)

But sure, saving opcode space, makes sense to me.

Btw, I'd still be interested about this:

> +static inline void clwb(volatile void *__p)
> +{
> +     alternative_io_2(".byte " __stringify(NOP_DS_PREFIX) "; clflush %P0",

Any particular reason for using 0x3e as a prefix to have the insns be
the same size or is it simply because CLFLUSH can stomach it?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
