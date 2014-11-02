Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaKBMfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 07:35:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39835 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbaKBMfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 07:35:43 -0500
Date: Sun, 2 Nov 2014 13:35:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: Build module on x86-32
Message-ID: <20141102123538.GE5229@pd.tnic>
References: <20141102102212.GA7034@polanet.pl>
 <20141102103300.GB5229@pd.tnic>
 <20141102121139.GA7000@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141102121139.GA7000@polanet.pl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 01:11:39PM +0100, Tomasz Pala wrote:
> On Sun, Nov 02, 2014 at 11:33:00 +0100, Borislav Petkov wrote:
> 
> > Not enabling it on 32-bit was a conscious decision for the simple reason
> > that with the current DIMM sizes, you can have 1 or 2 DIMMs tops which
> > you can use on 32-bit and having a fat driver mapping memory errors to
> > DIMMs in that case does seem like a waste of time, energy, resources...
> > you name it.
> 
> In my case it's not about mapping but Detection.

Detection of what? Which DIMMs or simply error reporting? Because you
can get reported errors with simply enabling CONFIG_EDAC_DECODE_MCE -
you don't really need amd64_edac for that.

Or do you want for amd64_edac to try to pinpoint which DIMMs are causing
the errors too?

> === begin story ===
> 
> Recently my PostgreSQL db failed with:
> 
> invalid page header in block 240 of relation base/49095/161613
> 
> which was fortunately 'fixed' by:
> 
> echo 1 > /proc/sys/vm/drop_caches
> 
> It turned out that there were on-disk differences between RAID1 (md)
> components, not only shown by next run of mdadm-checkarray, but also
> visible in actual filesystem after splitting RAID1 into separate
> volumes. There were no problems registered in S.M.A.R.T. logs, but
> _somehow_ my data got corrupted and I got not a single diagnostic tool
> available. There were no power outages or any other abrupt events, it
> just happened, without any reason. I've found some page cache corruption
> reports on the net, but none of those matched my conditions.
> 
> Currently I'm using checksums at application level (available since
> PostgreSQL 9.3) and FS level (BTRFS) and EDAC for 4x1 GB ECC UDIMM
> (I did replace 2x2 GB non-ECC with these).
> 
> If I could I'd use block-level checksumming or setup RAID1 to
> scrub-on-read mode, as this system has very low usage volume and I don't
> care about performance at all. Unfortunately SATA T13 didn't made it to
> the market, and SCSI drives with DIF/DIX are overkill for this system.

So were you able to confirm that those errors went away after replacing
the DIMMs?

> There is absolutely no reason for you to forbid me using EDAC.
> 
> And your reasoning is flawn because:
...

First of all, you need to relax yourself. Just calm down a bit, maybe
take a walk first. Take a deep breath, whatever helps.

No one is forbidding you anything - we're simply talking here. And since
you haven't heard my point yet, acting offended for no apparent reason
is simply waste of energy on your part.

Now, to the technical side:

I'm not talking about your time, energy and resources but about mine! I
don't have 32-bit configurations to test 32-bit amd64_edac and am not
willing to go buy any. So let me flip your question: are you going to
test amd64_edac on 32-bit and fix issues when people report them?

If so, I'll gladly enable it there and bounce all such bugs to you for
fixing after people start using it. Oh, and also, all fixes for 32-bit
should *not* break 64-bit amd64_edac so you'll have to test that too.

And this is the main reason why it isn't enabled on 32-bit: lack of
resources and desire to maintain. Very simple.

And finally, if you're only interested in error rates,
CONFIG_EDAC_DECODE_MCE is enough - you get each error reported but
without the amd64_edac output.

> Once again: the circuits are working, there is no technical reason not
> to use them. It's up to the owner to decide whether it makes sense.

Not only to the owner, as I've stated above.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
