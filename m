Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaBJR3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:29:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbaBJR3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:29:02 -0500
Date: Mon, 10 Feb 2014 18:28:53 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, fengguang.wu@intel.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, bp@alien8.de,
        ebiederm@xmission.com, akpm@linux-foundation.org, hpa@linux.intel.com,
        jingbai.ma@hp.com
Subject: Re: [RESEND PATCH v10] x86, apic, kexec, Documentation: Add
 disable_cpu_apicid kernel parameter
Message-ID: <20140210182853.15fccd8e@hananiah.suse.cz>
In-Reply-To: <20140115181426.GC29244@redhat.com>
References: <20140115064458.1545.38775.stgit@localhost6.localdomain6>
	<20140115170525.GF3180@redhat.com>
	<52D6C4B6.8010804@zytor.com>
	<20140115174714.GG3180@redhat.com>
	<52D6CB57.8030804@zytor.com>
	<20140115181426.GC29244@redhat.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 13:14:26 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Jan 15, 2014 at 09:54:31AM -0800, H. Peter Anvin wrote:
> > On 01/15/2014 09:47 AM, Vivek Goyal wrote:
> > > On Wed, Jan 15, 2014 at 09:26:14AM -0800, H. Peter Anvin wrote:
> > >> On 01/15/2014 09:05 AM, Vivek Goyal wrote:
> > >>>
> > >>> I think this is a reasonable approach to solve the issue. Use a command
> > >>> line to not bring up specific cpu in second kernel which can create
> > >>> problems.
> > >>>
> > >>> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> > >>>
> > >>> hpa, I know you are not excited about this approach. If you made up your
> > >>> mind that this appoarch is not worth pursuing, please do suggest what
> > >>> would you like to see and we can give that a try.
> > >>>
> > >>> We want to solve this problem as on large memory machines saving dump can
> > >>> take lot of time and we want to bring up multiple cpus and speed up
> > >>> compression and save on dump time.
> > >>>
> > >>
> > >> I'm not excited about kdump's reliance on the command line, since it
> > >> seems to be a neverending source of trouble, simply because the command
> > >> line is fundamentally intended as a human interface.
> > > 
> > > So in general, what are the alternatives? Either we figure out that kernel
> > > is booting as kdump kernel and do things differently. That seems even
> > > worse as what do we want in kdump kernel will change over a period of
> > > time.
> > > 
> > > Other thing is that pass more information in bootparams. But that does
> > > not seem much different than command line to me.
> > > 
> > 
> > It is the commingling of semantics that is the problem.  Command line
> > options are generally imperative, "do this".  What you want in the kdump
> > situation, as you yourself state above, is get a description of the
> > current situation and let the kdump side choose the action to take.
> > 
> > As a transport mechanism the command line suffers from limited size and
> > that you have to share it with an arbitrary amount of user-provided
> > options that may or may not be essential.
> 
> For large amount of info like memory map, I agree that passing on command
> line is not a good idea. (/me taks the blame for doing that). That's why
> in new patches I want to move to pass new map on bootparams and pass
> saved_max_pfn on command line instead. This is a fresh start so we
> probably can ignore compatibility with older kernels for this new
> interface and set things right.
> 
> But for smaller options, command line seems to be good that they don't
> consume precious space in bootparams. If we introduce an option today,
> we are not sure if kdump will continue to use that option down the line
> or not. For example, few years down the line, we might be able to send
> INIT IPI to boot cpu too and not need disable_cpu_apicid.

Yes, that was my thinking. We really only need all this, because
current BIOS implementations do not offer a way to override the default
initialization routine on a BSP. In fact, I disassembled the INIT
vector of a few BIOSes to see if the old 286 way of leaving protected
mode (via a CMOS location) is still supported and might be used at
least on some hardware. It is not, but that doesn't mean future BIOSes
may not re-implement something like that.

Sorry for coming late to the party...

Petr Tesarik
