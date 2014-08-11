Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaHKOBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:01:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43962 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbaHKOBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:01:08 -0400
Date: Mon, 11 Aug 2014 16:00:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: H Peter Anvin <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: early intel microcode update violating alignment rules
Message-ID: <20140811140057.GA21693@pd.tnic>
References: <20140809231911.GA4843@khazad-dum.debian.net>
 <20140811102245.GC4236@nazgul.tnic>
 <20140811131613.GA4541@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140811131613.GA4541@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 10:16:13AM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 11 Aug 2014, Borislav Petkov wrote:
> > On Sat, Aug 09, 2014 at 08:19:11PM -0300, Henrique de Moraes Holschuh wrote:
> > > Is there a way to fix this in the kernel for the BSP?
> > 
> > I think you're looking at this the wrong way around. :-) The thing that
> > needs fixing is the SDM since some CPUs seem to accept 16-byte unaligned
> > microcode just fine.
> 
> I often wonder how much of the Intel SDM is really a fairy tale...  it
> certainly has enough legends from times long past inside ;-)  But just like
> old stories, should you forget all about them, they sometimes grow fangs
> back and get you when you're least prepared.
> 
> Now, seriously, we're neither aligning the thing, nor checking any of it for
> alignment, so userspace can mess with us at will.  Unless it is trying to be
> actively malicious, we'll get 4-byte alignment out of userspace for the data
> inside the early initramfs (assuming the use of the common cpio tools: GNU
> cpio and GNU pax), but that's it.
> 
> I can easily propose fixes to reject incorrectly aligned data (and will do
> so), but you *really* don't want to know the kind of crap I came up with to
> try to align the microcode update for the BSP: Standard Lovecraftian Mythos
> Safety Procedures apply!  So I am turning to you for ideas...

It seems to me you're looking for issues where there are none. We simply
have to ask Intel people what's with the 16-byte alignment and fix
the SDM, apparently. If the processor accepts the non-16-byte-aligned
update, why do you care?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
