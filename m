Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3KULQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:16:45 -0500
Received: from ozlabs.org ([203.10.76.45]:34832 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab3KULQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:16:43 -0500
Date: Thu, 21 Nov 2013 22:16:39 +1100
From: Michael Ellerman <mpe@ellerman.id.au>
To: Jason Baron <jbaron@akamai.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>
Subject: Re: [PATCH v2] panic: Make panic_timeout configurable
Message-ID: <20131121111638.GA15913@concordia>
References: <20131118210436.233B5202A@prod-mail-relay06.akamai.com>
 <20131118143059.afe17d2faced16171a05eb10@linux-foundation.org>
 <528A9F24.1000206@akamai.com>
 <20131119070905.GF32367@gmail.com>
 <528BE05E.8090501@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528BE05E.8090501@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 05:04:14PM -0500, Jason Baron wrote:
> On 11/19/2013 02:09 AM, Ingo Molnar wrote:
> > 
> > * Jason Baron <jbaron@akamai.com> wrote:
> > 
> >> On 11/18/2013 05:30 PM, Andrew Morton wrote:
> >>> On Mon, 18 Nov 2013 21:04:36 +0000 (GMT) Jason Baron <jbaron@akamai.com> wrote:
> >>>
> >>>> The panic_timeout value can be set via the command line option 'panic=x', or via
> >>>> /proc/sys/kernel/panic, however that is not sufficient when the panic occurs
> >>>> before we are able to set up these values. Thus, add a CONFIG_PANIC_TIMEOUT
> >>>> so that we can set the desired value from the .config.
> >>>>
> >>>> The default panic_timeout value continues to be 0 - wait forever, 
> >>>> except for powerpc and mips, which have been defaulted to 180 and 
> >>>> 5 respectively. This is in keeping with the fact that these 
> >>>> arches already set panic_timeout in their arch init code. 
> >>>> However, I found three exceptions- two in mips and one in powerpc 
> >>>> where the settings didn't match these default values. In those 
> >>>> cases, I left the arch code so it continues to override, in case 
> >>>> the user has not changed from the default. It would nice if these 
> >>>> arches had one default value, or if we could determine the 
> >>>> correct setting at compile-time.
...
> 
> Sure, I can round up all the related patches in this area that make
> sense and re-submit as a series.
> 
> Felipe, would the CONFIG_PANIC_TIMEOUT=xx .config parameter work for your
> needs, or would you still like to see the command-line processing moved
> up?
> 
> I'd also like to hear from the PowerPC folks about the arch defaults
> there. Now, that mips is ok with CONFIG_PANIC_TIMEOUT, PowerPC is the
> only arch doing specific initialization of 'panic_timeout'.

Hi Jason,

I think we'd like to choose the value at runtime, as we do now. The
powerpc arch supports a wide spread of different hardware, so it's nice
to be able to customise the value based on the platform. Also we build a
single kernel that boots on many platforms, and so we can't pick the
value at compile time.

cheers
