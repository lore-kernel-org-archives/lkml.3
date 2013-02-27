Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605Ab3B0R7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:59:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51446 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab3B0R7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:59:43 -0500
Date: Wed, 27 Feb 2013 17:57:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Peter Korsgaard <jacmet@sunsite.dk>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, David Sterba <dsterba@suse.cz>,
        Richard Cochran <richardcochran@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com
Subject: Re: [RFC PATCH v2 0/4] Add support for LZ4-compressed kernel
Message-ID: <20130227175750.GD17833@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.03.1302261557220.1254@syhkavp.arg> <87fw0i7n6d.fsf@dell.be.48ers.dk> <20130226221027.GW17833@n2100.arm.linux.org.uk> <1361929234.1924.8.camel@joe-AO722> <20130227095609.GY17833@n2100.arm.linux.org.uk> <1361980152.2035.13.camel@joe-AO722> <20130227163118.GB17833@n2100.arm.linux.org.uk> <1361984688.2035.20.camel@joe-AO722> <alpine.LFD.2.03.1302271211360.1254@syhkavp.arg> <1361986787.20540.8.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361986787.20540.8.camel@joe-AO722>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 09:39:47AM -0800, Joe Perches wrote:
> On Wed, 2013-02-27 at 12:16 -0500, Nicolas Pitre wrote:
> > On Wed, 27 Feb 2013, Joe Perches wrote:
> > > On Wed, 2013-02-27 at 16:31 +0000, Russell King - ARM Linux wrote:
> > > > On Wed, Feb 27, 2013 at 07:49:12AM -0800, Joe Perches wrote:
> > > > > On Wed, 2013-02-27 at 09:56 +0000, Russell King - ARM Linux wrote:
> > > > > > On Tue, Feb 26, 2013 at 05:40:34PM -0800, Joe Perches wrote:
> > > > > > > On Tue, 2013-02-26 at 22:10 +0000, Russell King - ARM Linux wrote:
> > > > > > > > So... for a selected kernel version of a particular size, can we please
> > > > > > > > have a comparison between the new LZO code and this LZ4 code, so that
> > > > > > > > we can see whether it's worth updating the LZO code or replacing the
> > > > > > > > LZO code with LZ4?
> > > > > > > 
> > > > > > > How could it be questionable that it's worth updating the LZO code?
> > > > > > 
> > > > > > Please read the comments against the previous posting of these patches
> > > > > > where I first stated this argument - and with agreement from those
> > > > > > following the thread.  The thread started on 26 Jan 2013.  Thanks.
> > > > > 
> > > > > https://lkml.org/lkml/2013/1/29/145
> > > > > 
> > > > > I did not and do not see significant value in
> > > > > adding LZ4 given Markus' LZO improvements.
> > > > 
> > > > Sorry, a 66% increase in decompression speed over the updated LZO code
> > > > isn't "significant value" ?
> > > 
> > > We disagree.
> > > 
> > > > I'm curious - what in your mind qualifies "significant value" ?
> > > 
> > > faster boot time. smaller, faster overall code.
> > 
> > Sorry, but you certainly successfully got me confused, and probably 
> > others as well.
> > 
> > RMK says that "66% increase in decompression speed over LZO" is 
> > significant.  You apparently disagree with that.
> 
> Yeah, I can see how that can be interpreted.
> I'm referring only to the new LZO.
> 
> I guess Russell has not reviewed the new LZO.
> 
> There is apparently no speed increase for LZ4 over
> the new LZO.

Total claptrap.  I've no idea where you're getting your data from, but
it's franky wrong and you're now being totally misleading to anyone
else reading this thread.

I explicitly asked for a comparison of the _new_ LZO vs the LZ4 code,
and this is what I received from Kyungsik Lee in this thread:

	Compiler: Linaro ARM gcc 4.6.2
	2. ARMv7, 1.7GHz based board
	   Kernel: linux 3.7
	   Uncompressed Kernel Size: 14MB
	         Compressed Size  Decompression Speed
	    LZO  6.0MB            34.1MB/s            Old
	         ----------------------------------------
	         6.0MB            34.7MB/s            New
	         6.0MB            52.2MB/s(UA)
	    =============================================
	    LZ4  6.5MB            86.7MB/s
	UA: Unaligned memory Access support

And my statement of a "66% increase in speed" of LZ4 is comparing the
_new_ LZO code with unaligned access with the LZ4 code.

Now, you refer to Markus' results - but Markus' results do not say what
they're comparing - they don't say what the size of the compressed image
is, nor what the size of the uncompressed image was.

Now, Markus' results show a 42% increase in speed between the LZO-2012
and LZO-2013-UA versions (do the calculation yourself - I'm sure you're
capable of that?  If not, we can turn this into a maths lesson too).
The above shows a 53% increase in speed between the existing LZO code
and the new LZO code with unaligned accesses.

_But_ the above shows an additional 66% increase between the new LZO
code with unaligned accesses and LZ4.  Or, a whopping 150% increase
in speed over the _existing_ LZO code.

So please, stop stating what I have and have not reviewed.  Unlike you,
I _have_ been following everything that's been said in this thread, and
 - unlike you - I have analysed the figures put forward and drawn
conclusions which are fully supported by the published data from them,
and stated them - now many times.
