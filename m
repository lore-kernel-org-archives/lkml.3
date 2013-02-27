Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431Ab3B0Rjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:39:51 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55027 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755428Ab3B0Rjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:39:49 -0500
Message-ID: <1361986787.20540.8.camel@joe-AO722>
Subject: Re: [RFC PATCH v2 0/4] Add support for LZ4-compressed kernel
From: Joe Perches <joe@perches.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Korsgaard <jacmet@sunsite.dk>,
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
Date: Wed, 27 Feb 2013 09:39:47 -0800
In-Reply-To: <alpine.LFD.2.03.1302271211360.1254@syhkavp.arg>
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
	 <512D1C12.4080109@oberhumer.com>
	 <alpine.LFD.2.03.1302261557220.1254@syhkavp.arg>
	 <87fw0i7n6d.fsf@dell.be.48ers.dk>
	 <20130226221027.GW17833@n2100.arm.linux.org.uk>
	 <1361929234.1924.8.camel@joe-AO722>
	 <20130227095609.GY17833@n2100.arm.linux.org.uk>
	 <1361980152.2035.13.camel@joe-AO722>
	 <20130227163118.GB17833@n2100.arm.linux.org.uk>
	 <1361984688.2035.20.camel@joe-AO722>
	 <alpine.LFD.2.03.1302271211360.1254@syhkavp.arg>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-27 at 12:16 -0500, Nicolas Pitre wrote:
> On Wed, 27 Feb 2013, Joe Perches wrote:
> > On Wed, 2013-02-27 at 16:31 +0000, Russell King - ARM Linux wrote:
> > > On Wed, Feb 27, 2013 at 07:49:12AM -0800, Joe Perches wrote:
> > > > On Wed, 2013-02-27 at 09:56 +0000, Russell King - ARM Linux wrote:
> > > > > On Tue, Feb 26, 2013 at 05:40:34PM -0800, Joe Perches wrote:
> > > > > > On Tue, 2013-02-26 at 22:10 +0000, Russell King - ARM Linux wrote:
> > > > > > > So... for a selected kernel version of a particular size, can we please
> > > > > > > have a comparison between the new LZO code and this LZ4 code, so that
> > > > > > > we can see whether it's worth updating the LZO code or replacing the
> > > > > > > LZO code with LZ4?
> > > > > > 
> > > > > > How could it be questionable that it's worth updating the LZO code?
> > > > > 
> > > > > Please read the comments against the previous posting of these patches
> > > > > where I first stated this argument - and with agreement from those
> > > > > following the thread.  The thread started on 26 Jan 2013.  Thanks.
> > > > 
> > > > https://lkml.org/lkml/2013/1/29/145
> > > > 
> > > > I did not and do not see significant value in
> > > > adding LZ4 given Markus' LZO improvements.
> > > 
> > > Sorry, a 66% increase in decompression speed over the updated LZO code
> > > isn't "significant value" ?
> > 
> > We disagree.
> > 
> > > I'm curious - what in your mind qualifies "significant value" ?
> > 
> > faster boot time. smaller, faster overall code.
> 
> Sorry, but you certainly successfully got me confused, and probably 
> others as well.
> 
> RMK says that "66% increase in decompression speed over LZO" is 
> significant.  You apparently disagree with that.

Yeah, I can see how that can be interpreted.
I'm referring only to the new LZO.

I guess Russell has not reviewed the new LZO.

There is apparently no speed increase for LZ4 over
the new LZO.

I believe Markus has shown comparison testing in
this very thread.

https://patchwork.kernel.org/patch/2187441/

> Then you say that faster boot time is significant.

Increasing speed in incumbent code without adding
defects is always useful no?.  Replacing incumbent
code with new code should be debated for utility.

I still think there's not much value in adding LZ4.
LZ4 is not not faster than LZO, it's just more code.

