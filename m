Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab3CTRC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:02:59 -0400
Received: from mail.digium.com ([216.207.245.2]:37009 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab3CTRC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:02:57 -0400
Date: Wed, 20 Mar 2013 12:03:11 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [3.9-rc1] Bug in bootup code or debug code?
Message-ID: <20130320170310.GA23362@digium.com>
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp>
 <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp>
 <201303132224.BEC60922.JStQOFMVFFOHLO@I-love.SAKURA.ne.jp>
 <3E5A0FA7E9CA944F9D5414FEC6C71220528C2DFF@ORSMSX105.amr.corp.intel.com>
 <5140BB13.10806@linux.intel.com>
 <201303140545.DAC69253.FtSJOOFMHVFOLQ@I-love.SAKURA.ne.jp>
 <3E5A0FA7E9CA944F9D5414FEC6C7122055946F23@ORSMSX105.amr.corp.intel.com>
 <20130320142444.GA10492@digium.com>
 <3E5A0FA7E9CA944F9D5414FEC6C712205594724E@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712205594724E@ORSMSX105.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 04:32:14PM +0000, Yu, Fenghua wrote:
> > From: Shaun Ruffell [mailto:sruffell@digium.com]
> > On Tue, Mar 19, 2013 at 10:12:39PM +0000, Yu, Fenghua wrote:
> > > > From: Tetsuo Handa [mailto:penguin-kernel@I-love.SAKURA.ne.jp]
> > > > H. Peter Anvin wrote:
>  
> > Hi Fenghua,
> > 
> > I ran into the same issue on a test system I use (not a virtual
> > machine) and went through basically the same process as Dave
> > Hansen w/bisecting before finding this thread.
> > 
> > Any chance you could send the patch to the mailing list and I could
> > also throw it on my test system?
> Hi, Shaun,
> 
> The patch is in tip.git tree now. You can get it from:
> http://git.kernel.org/tip/c83a9d5e425d4678b05ca058fec6254f18601474
> 
> Please let us know if the patch fixes the issue you saw.

Thanks for the link. That patch applied on 3.9-rc3 did allow me to boot with my
default kernel config.

Not related to this patch, and not sure it really matters, but FYI: I just
noticed the following warning when building the patched kernel:

WARNING: vmlinux.o(.text+0x2a1a7): Section mismatch in reference from the function apply_microcode_early() to the function .cpuinit.text:print_ucode()
The function apply_microcode_early() references
the function __cpuinit print_ucode().
This is often because apply_microcode_early lacks a __cpuinit 
annotation or the annotation of print_ucode is wrong.

Thanks,
Shaun
