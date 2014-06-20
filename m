Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbaFTSQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:16:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbaFTSQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:16:28 -0400
Date: Fri, 20 Jun 2014 14:16:00 -0400
From: Dave Jones <davej@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave@sr71.net>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
Message-ID: <20140620181600.GA1331@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
	x86@kernel.org, Andi Kleen <ak@linux.intel.com>
References: <20140620161736.D6AC16FD@viggo.jf.intel.com>
 <20140620161740.BFB00798@viggo.jf.intel.com>
 <53A46008.5060509@zytor.com>
 <53A4619C.8020100@sr71.net>
 <53A46365.6090101@zytor.com>
 <20140620174345.GD11391@pd.tnic>
 <53A473AA.7050301@zytor.com>
 <20140620180523.GF11391@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620180523.GF11391@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 08:05:23PM +0200, Borislav Petkov wrote:
 > On Fri, Jun 20, 2014 at 10:47:22AM -0700, H. Peter Anvin wrote:
 > > This is run before static_cpu_has().
 > 
 > static_cpu_has_safe() then - I didn't do it for no reason :-)
 > 
 > > The point, though, was that we "enforce" (taint) on 32 bits but not on
 > > 64 bits, which is clearly wrong.
 > 
 > Yeah, K7 is 32-bit only.
 > 
 > > My inclination is to completely kill amd_k7_smp_check() entirely,
 > > since noone seems to know when it actually matters and it is clearly
 > > historic.
 > 
 > I think DaveJ should know something about it - he gave that impression
 > last time when we were discussing 8c90487cdc64 ("Rename TAINT_UNSAFE_SMP
 > to TAINT_CPU_OUT_OF_SPEC").

AMD sold two separate SKUs: the Athlon XP and the Athlon MP.
Only the latter was supposedly "certified" for use in multi-processor
boards.  People found out however that sometimes the XP's 'worked'
if you modded them (see http://www.hardwaresecrets.com/article/How-to-Transform-an-Athlon-XP-into-an-Athlon-MP/24)

There was belief that AMD had reason beyond "more price mark-up for MP's"
and that those fuses had been blown for good reason (failing validation
in some conditions for eg).

I doubt anyone is actually even running such a system any more on
a modern kernel, and any weird crashes would be written off more by
"you're running 10+ year old hardware, it's probably broken" than
"it was never meant to do that".

	Dave

