Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbbAHQxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:53:00 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52728 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbbAHQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:52:58 -0500
Date: Thu, 8 Jan 2015 17:52:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Mark Seaborn <mseaborn@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20150108165255.GA19657@amd>
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
 <20141224220818.GA17655@amd>
 <20150105192329.5f32c155@lxorguk.ukuu.org.uk>
 <CALCETrXby82sgbGTcSZFj54t=resYcwtPbcFRNh6Ksbr+Ow8HQ@mail.gmail.com>
 <20150106014718.GA23775@node.dhcp.inet.fi>
 <CALCETrV1O1MFJeY6WacF+QHdBGG7HoHdVQy=n951=Y+=g+h7mQ@mail.gmail.com>
 <20150106021836.GA24121@node.dhcp.inet.fi>
 <CALCETrXpJ7CPAKeh9nLA=PoCBT8w8NfhZg5cgUyG9BUtp2Jv+w@mail.gmail.com>
 <20150108130325.0592b18b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108130325.0592b18b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2015-01-08 13:03:25, One Thousand Gnomes wrote:
> On Mon, 5 Jan 2015 18:26:07 -0800
> Andy Lutomirski <luto@amacapital.net> wrote:

> > > I don't know for sure, but it looks likely to me according to claim in the
> > > paper (8MB). But it still can be sombody else's data: 644 file on
> > > hugetlbfs mmap()ed r/o by anyone.
> 
> Thats less of a concern I think. As far as I can tell it would depend how
> the memory is wired what actually gets hit. I'm not clear if its within
> the range or not.

I think it can hit outside the specified area, yes.

> > > When I read the paper I thought that vdso would be interesting target for
> > > the attack, but having all these constrains in place, it's hard aim the
> > > attack anything widely used.
> > >
> > 
> > The vdso and the vvar page are both at probably-well-known physical
> > addresses, so you can at least target the kernel a little bit.  I
> > *think* that kASLR helps a little bit here.
> 
> SMEP likewise if you were able to use 1GB to corrupt matching lines
> elsewhere in RAM (eg the syscall table), but that would I think depend
> how the RAM is physically configured.
> 
> Thats why the large TLB case worries me. With 4K pages and to an extent
> with 2MB pages its actually quite hard to line up an attack if you know
> something about the target. With 1GB hugepages you control the lower bits
> of the physical address precisely. The question is whether that merely
> enables you to decide where to shoot yourself or it goes beyond that
> ?

I think you shoot pretty much randomly. Some cells are more likely to
flip, some are less likely, but that depends on concrete DRAM chip.

> (Outside HPC anyway: for HPC cases it bites both ways I suspect - you've
> got the ability to ensure you don't hit those access patterns while using
> 1GB pages, but also nothing to randomise stuff to make them unlikely if
> you happen to have worst case aligned data).

I don't think it is a problem for HPC. You really can't do this by
accident. You need very specific pattern of DRAM accesses. Get it 10
times slower, and DRAM can handle that.

Actually, I don't think you can trigger it without performing the
cache flushing instructions. 


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
