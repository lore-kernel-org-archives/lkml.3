Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaBROaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:30:21 -0500
Received: from imap.thunk.org ([74.207.234.97]:59535 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505AbaBROaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:30:17 -0500
Date: Tue, 18 Feb 2014 09:30:05 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
        viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
 for fallocate
Message-ID: <20140218143005.GO26580@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Namjae Jeon <linkinjeon@gmail.com>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com,
	adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
References: <1391319874-3203-1-git-send-email-linkinjeon@gmail.com>
 <alpine.LFD.2.00.1402111209450.2225@localhost.localdomain>
 <CAKYAXd-bD6ZZgpc9E8V1kD9Dj2wrCkbi1i6drNBdUAwsMiv5gg@mail.gmail.com>
 <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
 <CAKYAXd_xpWg-=T_1PghL_u9wDKTX_Ey5mJxbgVVKth8NoexQQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd_xpWg-=T_1PghL_u9wDKTX_Ey5mJxbgVVKth8NoexQQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae,

Did you respond to Matthew Wilcox's comments/question from Feb. 2nd?

> > What if the file is mmaped at the time somebody issues this command?
> > Seems to me we should drop pagecache pages that overlap with the
> > removed blocks.  If the removed range is not a multiple of PAGE_SIZE,
> > then we should also drop any pagecache pages after the removed range.
>
> Oops, forgot to add "and if it is a multiple of page size, then we need
> to update the offsets of any pages after the removed page".

Dave responded that XFS does the right thing when doing a punch hole
operation, but it wasn't obvious to me whether FL_COLLAPSE_RANGE does
the right thing with ext4.

Thanks,

					- Ted
