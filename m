Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3CKJbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:31:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39684 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab3CKJbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:31:45 -0400
Date: Mon, 11 Mar 2013 02:31:35 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Zach Brown <zab@redhat.com>
Cc: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ric Wheeler <rwheeler@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: New copyfile system call - discuss before LSF?
Message-ID: <20130311093134.GI7783@localhost>
Mail-Followup-To: Zach Brown <zab@redhat.com>,
	"Myklebust, Trond" <Trond.Myklebust@netapp.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ric Wheeler <rwheeler@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Chris L. Mason" <clmason@fusionio.com>,
	Christoph Hellwig <hch@infradead.org>,
	Alexander Viro <aviro@redhat.com>,
	"Martin K. Petersen" <mkp@mkp.net>, Hannes Reinecke <hare@suse.de>
References: <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net>
 <512BD44C.40907@amacapital.net>
 <512BDC82.5060203@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA928699C17@sacexcmbx05-prd.hq.netapp.com>
 <CALCETrVXxdJ0Pg7wLS9T7mHRj8Ak2M1Yn3EPE_eBmHN3L9+70A@mail.gmail.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA92869CE90@sacexcmbx05-prd.hq.netapp.com>
 <CALCETrU-cfYeEnh6DF4f6z=d0gJsPd1rfShbPDYF4kX8R+8eRQ@mail.gmail.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA92869CFCE@sacexcmbx05-prd.hq.netapp.com>
 <20130226000301.GG1658@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226000301.GG1658@lenny.home.zabbo.net>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 04:03:01PM -0800, Zach Brown wrote:
> > >   I think it would be neat if it couldn't
> > > corrupt data.
> > 
> > It would also be neat if the moon were made of cheese...
> 
> And there we have the lsf2013 t-shirt slogan.  I think we're done here!
> 
> - z

Hey Everyone,
	So, of course, this thread happened while I was celebrating my
10-year anniversary on a warm, sunny island.  I won't trade.  But let me
drop my $0.02 in here.
	First, we have our T-shirt slogan.  That overrides every other
concern.
	Second, I agree that moving forward on anything is better than
not.  I haven't delivered the updated fastcopy(2) patch I promised two
years ago, and I have to admit that I can't promise code on any sane
timeframe.
	Back when I was working on this, I thought that link(2) was a
good model for a full-file copy.  Thus I came up with reflink(2).  This
eventually became the fastcopyu(2) proposal discussed two years ago.  I
did not think, and I still don't think, that we should conflate the API
for "copy/clone this file in some way" (ala fastcopy(2)) with
"duplicate/link this range of bytes" (ala BTRFS_IOC_CLONE_RANGE).  I
thought that splice(2) or something like it was a better fit for ranges;
this thread has already had the same thought.
	fastcopy(2) had a provision for CoW for atomicity, including
metadata.  This is because ocfs2 reflinks *can* provide atomic clones
with metadata included.  I would like any new proposal to allow for
that.  If it does not, of course, callers can continue to use
OCFS2_IOC_REFLINK, but I'd rather make it part of the generic behavior,
so that generic tools come with it.

Joel

-- 

"You don't make the poor richer by making the rich poorer."
	- Sir Winston Churchill

			http://www.jlbec.org/
			jlbec@evilplan.org
