Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624AbaKMSOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:14:18 -0500
Received: from mga03.intel.com ([134.134.136.65]:60239 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610AbaKMSOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:14:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,379,1413270000"; 
   d="scan'208";a="607394500"
Date: Thu, 13 Nov 2014 20:14:11 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@amacapital.net>, intel-gfx@lists.freedesktop.org,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>, Ingo Molnar <mingo@kernel.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] x86: Use clwb in drm_clflush_virt_range
Message-ID: <20141113181411.GU10649@intel.com>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
 <1415731396-19364-7-git-send-email-ross.zwisler@linux.intel.com>
 <5464220D.6090204@amacapital.net>
 <20141113112017.GA14416@pd.tnic>
 <CALCETrV2E-LBHLTV6zJ=nfw8ijjV8VZoYAinXdg9ZaOryfqquw@mail.gmail.com>
 <20141113171133.GD14070@pd.tnic>
 <20141113173354.GT10649@intel.com>
 <20141113174734.GF14070@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141113174734.GF14070@pd.tnic>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 06:47:34PM +0100, Borislav Petkov wrote:
> On Thu, Nov 13, 2014 at 07:33:54PM +0200, Ville Syrjälä wrote:
> > We use it both ways in i915. So please don't break it.
> 
> Haha, we started from Intel with Ross' patch and made a full circle
> back. Maybe you guys should talk about it.
> 
> LOL. :-)

Indeed. The problem I see with these patches is that they don't actually
tell what the new instruction does, so a casual glance doesn't really
raise any red flags. Another excuse I can use is that I just got used
to the fact that the x86 hasn't historically bothered separating
invalidate and writeback and just does both. In my previous life on the
dark^Warm side I did actually know the difference :)

But there's plenty of blame to go around to the other side of the fence
too. We should have documented what we expect from these functions.
Currently you just have to know/guess, and that's just not good enough.

-- 
Ville Syrjälä
Intel OTC
