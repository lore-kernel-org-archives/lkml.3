Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3JQXRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:17:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:16462 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751085Ab3JQXRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:17:39 -0400
Date: Thu, 17 Oct 2013 19:17:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: trace-cmd problem with FC19
Message-ID: <20131017191736.632c233f@gandalf.local.home>
In-Reply-To: <20131017211143.GA29276@localhost>
References: <525FD328.1040204@broadcom.com>
	<20131017144116.044f3aaf@gandalf.local.home>
	<52604373.5010907@broadcom.com>
	<20131017162029.002485b1@gandalf.local.home>
	<CAEKwDSAucy8NziB=mcem7we9vnGHe=cWt-4Q1X7+Vt5dokY19A@mail.gmail.com>
	<20131017165656.54b8b985@gandalf.local.home>
	<20131017211143.GA29276@localhost>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 17:11:43 -0400
Bob Copeland <me@bobcopeland.com> wrote:

> On Thu, Oct 17, 2013 at 04:56:56PM -0400, Steven Rostedt wrote:
> > Hmm, are you sure?
> > 
> > You may want to do both:
> > 
> > sudo trace-cmd -v
> > which trace-cmd
> > 
> > to see which version it is.
> 
> To clarify - I ran into the referenced issue using an older,
> self-compiled version with a recent kernel.  The FC19 distro
> version may be fine, for all I know.
> 
> Arend says he used the latest version from the repo which should
> not be a problem, but just throwing that out there since the
> symptoms are similar.
> 

Yeah, there was a known breakage in 3.10. The problem was that the
breakage was a fix to the splice code that would help trace-cmd.
Unfortunately, trace-cmd had a bug in it that would cause the fix to
break it.

I released a fix for all versions of trace-cmd that's currently
supported, and some that are not (all the way down to the 1.0 series).
I had the fix go out several months before 3.10 was released, and
notified all the major distros about it.

Thus, if you are using an older version, then yes, it will be broken
with the newer kernel. Just upgrade to a newer release (you can even
keep the same X.X version as they all have the fix).

-- Steve
