Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab3ETSbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:31:41 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:50717 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab3ETSbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:31:40 -0400
Date: Mon, 20 May 2013 20:31:36 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        the arch/x86 maintainers <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "x86-64, init: Do not set NX bits on non-NX
 capable hardware"
Message-ID: <20130520183136.GB5348@dhcp22.suse.cz>
References: <20130514160108.GA5055@dhcp22.suse.cz>
 <1369062192-7066-1-git-send-email-mhocko@suse.cz>
 <519A483F.7070400@zytor.com>
 <20130520164335.GA9441@dhcp22.suse.cz>
 <CA+55aFzxdGOW=7-x+41U4SZB5par7jKU9vuuhFdsQfZOuLiLtw@mail.gmail.com>
 <20130520182306.GA5348@dhcp22.suse.cz>
 <519A6BC7.7060902@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519A6BC7.7060902@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 20-05-13 11:30:31, H. Peter Anvin wrote:
> On 05/20/2013 11:23 AM, Michal Hocko wrote:
> > On Mon 20-05-13 10:21:09, Linus Torvalds wrote:
> >> On Mon, May 20, 2013 at 9:43 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >>>
> >>> The configuration has been posted in the referenced thread:
> >>> https://lkml.org/lkml/2013/5/14/398
> >>
> >> Hmm. That's a regular intel i5 Sandybridge CPU. Which certainly has NX.
> >>
> >> Hmm. secondary_startup_64 isn't __initcode, is it? I think it's used
> >> for resuming the other CPU's too and for CPU hotplug. Yes/no?
> >>
> >> If so early_pmd_flags shouldn't be __initdata, I think.
> >>
> >> Michal, does it work if you don't do the revert, but just remove the
> >> __initdata instead?
> > 
> > Right you are! The following patch on top of your tree fixes the
> > problem. Thanks a lot. I will leave the proper changelog to somebody who
> > is more familiar with the area but AFAIU the real problem is that
> > early_pmd_flags is no longer available beacause the section is gone.
> > 
> 
> I'll write it up and send a pull request to Linus.

Thanks, Peter

-- 
Michal Hocko
SUSE Labs
