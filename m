Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3CWQ0I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 12:26:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56871 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab3CWQ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 12:26:06 -0400
Date: Sat, 23 Mar 2013 17:25:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 12/29] x86, tsx: Add a per thread transaction disable
 count
Message-ID: <20130323162558.GD10811@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	x86@kernel.org, Andi Kleen <ak@linux.intel.com>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
 <1364001923-10796-13-git-send-email-andi@firstfloor.org>
 <20130323115115.GA10821@pd.tnic>
 <20130323135156.GJ20853@two.firstfloor.org>
 <20130323155256.GB10811@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130323155256.GB10811@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 04:52:56PM +0100, Borislav Petkov wrote:
> And wow, the XOR is *actually* faster. That's whopping three cycles on
> AMD. Similar observation on SNB.

Ok, correction: I was looking at the wrong row in the table. The XOR
version with an immediate and mem access is actually as fast as the
INC/DEC mem versions: 4 cycles on AMD F10h and 6 on SNB, according to
the docs. I should've realized that there's still a mem access there...

Anyway, the rest stands.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
