Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaEZIJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:09:11 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:60397 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaEZIJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:09:10 -0400
Date: Mon, 26 May 2014 10:09:02 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: cris: arch-v32: drivers: axisflashmap.c:
 Cleaning up inconsistent NULL checks
Message-ID: <20140526080902.GL9198@axis.com>
References: <1400796009-12716-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140523070016.GG9198@axis.com>
 <CAFo99ga_G=Bsvagi5PFCiq++6CaAqtWUo5PS6VxLUEsTvEMqdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99ga_G=Bsvagi5PFCiq++6CaAqtWUo5PS6VxLUEsTvEMqdA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 06:40:17PM +0200, Rickard Strandqvist wrote:
> Hej Jesper!

Tjo!

> But in several other place in the feature ensures that main_mtd is not NULL.
> (That's what cppcheck base their misjudgment on too)
>
> Then all these checks are unnecessary?

No, it is still necessary to check for NULL, however as I wrote in my reply,
we do check for ptable_head, which is only set if main_mtd is set.

> You should know, looks like you've written most of the code in 2007 :)
>
> Best regards
> Rickard Strandqvist

/Jesper

> 2014-05-23 9:00 GMT+02:00 Jesper Nilsson <jesper.nilsson@axis.com>:
> > On Fri, May 23, 2014 at 12:00:09AM +0200, Rickard Strandqvist wrote:
> >> Cleaning up inconsistent NULL checks.
> >> There is otherwise a risk of a possible null pointer dereference.
> >>
> >> Was largely found by using a static code analysis program called cppcheck.
> >
> > ... and is a false positive.
> >
> > We can't enter this if-block unless ptable_head is set,
> > which is only set if main_mtd is set.
> >
> > It might be useful to add it anyways, but there's a refactoring
> > needed for the axisflashmaps, so I'll keep it for then.
> >
> > /^JN - Jesper Nilsson
> > --
> >                Jesper Nilsson -- jesper.nilsson@axis.com

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
