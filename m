Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbbAIQby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:31:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56329 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbbAIQbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:31:52 -0500
Date: Fri, 9 Jan 2015 17:31:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Mark Seaborn <mseaborn@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20150109163149.GA18076@amd>
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
 <20141224220818.GA17655@amd>
 <20150105192329.5f32c155@lxorguk.ukuu.org.uk>
 <CALCETrXby82sgbGTcSZFj54t=resYcwtPbcFRNh6Ksbr+Ow8HQ@mail.gmail.com>
 <20150106014718.GA23775@node.dhcp.inet.fi>
 <CALCETrV1O1MFJeY6WacF+QHdBGG7HoHdVQy=n951=Y+=g+h7mQ@mail.gmail.com>
 <20150106021836.GA24121@node.dhcp.inet.fi>
 <CALCETrXpJ7CPAKeh9nLA=PoCBT8w8NfhZg5cgUyG9BUtp2Jv+w@mail.gmail.com>
 <20150108130325.0592b18b@lxorguk.ukuu.org.uk>
 <54AFF8B5.8050305@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AFF8B5.8050305@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Then it's also quite trivial to induce cache misses without clflush, using just
> few addresses that map to the same cache set, without having to cycle throuh
> more memory than the cache size is.

Hmm. If you can do "clflush" without "clflush", and result is no more
then 10 times slower than "clflush", you can probably break it. Might
need two DIMMs so that you can use one to flush caches while
row-hammering the other one.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
