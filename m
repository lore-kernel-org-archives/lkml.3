Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab3GMGot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 02:44:49 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:46421 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3GMGof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 02:44:35 -0400
Date: Sat, 13 Jul 2013 08:44:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
Message-ID: <20130713064430.GA9153@gmail.com>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130712005023.GB31005@thunk.org>
 <20130712025745.GA24086@tuxdriver.com>
 <20130712033430.GA3798@kroah.com>
 <51E03AEE.5010403@zytor.com>
 <20130712172836.GA7627@kroah.com>
 <20130712175718.GA342@thunk.org>
 <51E0480A.2040905@zytor.com>
 <51E04AB9.1000003@zytor.com>
 <CA+55aFw0PvYBguFmacL0FC6V_hjGVcUWsrZ6HO9tuQof=yw5PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw0PvYBguFmacL0FC6V_hjGVcUWsrZ6HO9tuQof=yw5PA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Jul 12, 2013 at 11:28 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > OK, just read up some more on git notes, and *both* the assumptions I 
> > had made about git notes were fundamentally wrong.  Not sure how well 
> > they would scale, though, but stuffing metadata like additional 
> > Acked-by:, Tested-by: and Cc: stable into notes seems more viable 
> > after reading the spec.
> 
> I really don't want to use git notes for anything that actually gets 
> distributed.

Regardless of any scalability and other technical merits, allowing tags to 
go into a commit log entry via git notes would IMO dilute the value of 
Acked-by and Reviewed-by tags and it would actively hurt our kernel 
development workflow I think.

Today there's a time limit on acking/reviewing patches: if it did not 
arrive by the time the code was committed and pushed out, it does not get 
into the commit log, ever. That gives people an incentive to be active 
_before_ a patch gets applied.

And that's really how it should work IMO: the most important, most 
critical decision point is when a patch gets applied to a tree with the 
intent to send it upstream. Maintainers need the most help at that point. 
Anything after that, unless it points out actual problems or room for 
improvements (which will generate new commits), is not very useful.

So adding git notes after that point to add Acked-by or Reviewed-by tags 
is just post facto whitewashing, ego stroking or pointless act 
self-serving bureaucracy, beyond being a sign of a broken Git workflow to 
begin with.

Thanks,

	Ingo
