Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3KCOmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 09:42:31 -0500
Received: from relay3.sgi.com ([192.48.152.1]:51078 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753841Ab3KCOm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 09:42:29 -0500
Date: Sun, 3 Nov 2013 08:42:27 -0600
From: Russ Anderson <rja@sgi.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Josh Boyer <jwboyer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
Message-ID: <20131103144227.GB6926@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org> <20131103101825.GA6605@gmail.com> <52765DBC.1090208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52765DBC.1090208@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 09:29:16AM -0500, Prarit Bhargava wrote:
> On 11/03/2013 05:18 AM, Ingo Molnar wrote:
> > 
> > * Josh Boyer <jwboyer@redhat.com> wrote:
> > 
> >> The current range for SMP configs is 2 - 512, or a full 4096 in the case 
> >> of MAXSMP.  There are machines that have 1024 CPUs in them today and 
> >> configuring a kernel for that means you are forced to set MAXSMP.  This 
> >> adds additional unnecessary overhead.  While that overhead might be 
> >> considered tiny for large machines, it isn't necessarily so if you are 
> >> building a kernel that runs across a wide variety of machines.  We 
> >> increase the range to 1024 to help with this.
> >>
> >> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> >> ---
> >>  arch/x86/Kconfig | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> >> index f67e839..d726b2d 100644
> >> --- a/arch/x86/Kconfig
> >> +++ b/arch/x86/Kconfig
> >> @@ -825,7 +825,7 @@ config MAXSMP
> >>  config NR_CPUS
> >>  	int "Maximum number of CPUs" if SMP && !MAXSMP
> >>  	range 2 8 if SMP && X86_32 && !X86_BIGSMP
> >> -	range 2 512 if SMP && !MAXSMP
> >> +	range 2 1024 if SMP && !MAXSMP
> >>  	default "1" if !SMP
> >>  	default "4096" if MAXSMP
> >>  	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
> > 
> > Any reason not to allow it to go up to 4096? The original concern was that 
> > CPUS=4096 wasn't working very well and you had to select MAXSMP 
> > deliberately and keep all the pieces.
> > 
> > But today it's all pretty robust so I see no reason why not to allow up to 
> > 4096 CPUs.
> 
> Adding Russ from SGI as they are one of the consumers of a large CPU count.
> 
> I have no objections to raising this to 4096 FWIW.  I think it is a good idea,
> and it is long overdue.

I obviously agree with increasing to 4096.
The bigger the better.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
