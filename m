Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbaGONDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:03:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36665 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665AbaGONDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:03:10 -0400
Date: Tue, 15 Jul 2014 15:03:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: IMA: kernel reading files opened with O_DIRECT
Message-ID: <20140715130308.GA4109@amd.pavel.ucw.cz>
References: <53B3D3AA.3000408@samsung.com>
 <x49y4wbu54y.fsf@segfault.boston.devel.redhat.com>
 <20140702184050.GA24583@infradead.org>
 <20140711201054.GB18033@amd.pavel.ucw.cz>
 <CACE9dm8TW1+7bq6hJiOmoAw+w+ZD8Ma=Sf6a5ZM2HZ5X1Lcifw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACE9dm8TW1+7bq6hJiOmoAw+w+ZD8Ma=Sf6a5ZM2HZ5X1Lcifw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-07-12 01:22:04, Dmitry Kasatkin wrote:
> On 11 July 2014 23:10, Pavel Machek <pavel@ucw.cz> wrote:
> > On Wed 2014-07-02 11:40:50, Christoph Hellwig wrote:
> >> On Wed, Jul 02, 2014 at 11:55:41AM -0400, Jeff Moyer wrote:
> >> > It's acceptable.
> >>
> >> It's not because it will then also affect other reads going on at the
> >> same time.
> >>
> >> The whole concept of ima is just broken, and if you want to do these
> >> sort of verification they need to happen inside the filesystem and not
> >> above it.
> >
> > ...and doing it at filesystem layer would also permit verification of
> > per-block (64KB? 1MB?) hashes.
> 
> Please design one single and the best universal filesystem which
> does it.

Given the overhead whole-file hashing has, you don't need single best
operating system. All you need it either ext4 or btrfs.. depending on
when you want it in production.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
