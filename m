Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3FGPEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:04:30 -0400
Received: from kanga.kvack.org ([205.233.56.17]:55213 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab3FGPE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:04:28 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2013 11:04:28 EDT
Date: Fri, 7 Jun 2013 11:04:28 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Timo =?iso-8859-1?Q?Ter=E4s?= <timo.teras@iki.fi>
Subject: Re: [ 150/184] ipv4: check rt_genid in dst_check
Message-ID: <20130607150352.GS15183@kvack.org>
References: <20130604172136.519104713@1wt.eu> <1370585253.4021.93.camel@deadeye.wl.decadent.org.uk> <20130607145806.GR15183@kvack.org> <20130607150057.GF19006@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607150057.GF19006@1wt.eu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

On Fri, Jun 07, 2013 at 05:00:57PM +0200, Willy Tarreau wrote:
> On Fri, Jun 07, 2013 at 10:58:06AM -0400, Benjamin LaHaise wrote:
> > On Fri, Jun 07, 2013 at 07:07:33AM +0100, Ben Hutchings wrote:
> > > > This commit is based on the above, with the addition of verifying blackhole
> > > > routes in the same manner.
> > > 
> > > That addition doesn't seem to correspond to anything in mainline.  Why
> > > should 2.6.32 differ?
> > 
> > Fixing the issue with blackhole routes as it was accomplished in mainline 
> > would require pulling in a lot more code, and people were not interested 
> > in pulling in all of the dependencies given the much higher risk of trying 
> > to select the right subset of changes to include.  The addition of the 
> > single line of "dst->obsolete = -1;" in ipv4_dst_blackhole() was much 
> > easier to verify, and is in the spirit of the patch in question.  This is 
> > the minimal set of changes to fix the bug in question.
> 
> Thank you Ben, I'll add this description to the existing commit message.

A link to the test case for this issue might be helpful to include as well.  
It is at http://marc.info/?l=linux-netdev&m=135015076708950&w=2 .  Cheers,

		-ben

> Best regards,
> Willy

-- 
"Thought is the essence of where you are now."
