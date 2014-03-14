Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaCNJGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:06:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57729 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871AbaCNJGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:06:21 -0400
Date: Fri, 14 Mar 2014 10:06:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH] Fix northbridge quirk to assign correct NUMA node
Message-ID: <20140314090617.GA4697@pd.tnic>
References: <1394710981-3596-1-git-send-email-daniel@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1394710981-3596-1-git-send-email-daniel@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 07:43:01PM +0800, Daniel J Blueman wrote:
> For systems with multiple servers and routed fabric, all northbridges get
> assigned to the first server. Fix this by also using the node reported from
> the PCI bus. For single-fabric systems, the northbriges are on PCI bus 0
> by definition, which are on NUMA node 0 by definition, so this is invarient
> on most systems.

Yeah, I think this is of very low risk for !Numascale setups. :-) So

Acked-by: Borislav Petkov <bp@suse.de>

> Tested on fam10h and fam15h single and multi-fabric systems and candidate
> for stable.

I'm not sure about it - this is only reporting the wrong node, right?
Does anything depend on that node setting being correct and breaks due
to this?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
