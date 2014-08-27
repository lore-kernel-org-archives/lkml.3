Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934955AbaH0OS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:18:29 -0400
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:36124 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934828AbaH0OS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:18:27 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2014 10:18:27 EDT
X-MXL-Hash: 53fde8b31a6546cf-35e9b2f870c2c712d88f0dc9c6e52d6216b957d7
X-MXL-Hash: 53fde7750636a771-ee755c84cb931db331a9ac7fb7d81a6c30cdb256
Date: Wed, 27 Aug 2014 10:13:03 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
To: Jeff Moyer <jmoyer@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        "Jiri Kosina" <jkosina@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3 0/2] block,scsi: fixup blk_get_request dead queue
 scenarios
Message-ID: <20140827101303.45130274@jlaw-desktop.mno.stratus.com>
In-Reply-To: <x49iole6hcc.fsf@segfault.boston.devel.redhat.com>
References: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>
	<x49egw36u55.fsf@segfault.boston.devel.redhat.com>
	<53FCF9DB.6010501@kernel.dk>
	<x49mwar54ca.fsf@segfault.boston.devel.redhat.com>
	<53FCFD40.2010903@kernel.dk>
	<53FCFE01.8080701@kernel.dk>
	<x49iole6hcc.fsf@segfault.boston.devel.redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AnalysisOut: [v=2.1 cv=PtqHbm83 c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=2KTiUk5DT3cA:10 a=AeS]
X-AnalysisOut: [L823i6SsA:10 a=_KQqW7t0BisA:10 a=BLceEmwcHowA:10 a=kj9zAlc]
X-AnalysisOut: [Oel0A:10 a=uelBKuKpAAAA:8 a=YlVTAMxIAAAA:8 a=20KFwNOVAAAA:]
X-AnalysisOut: [8 a=g0VfTIXwA-t12kffwNoA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEU]
X-AnalysisOut: [A:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014082702); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014 18:01:23 -0400
Jeff Moyer <jmoyer@redhat.com> wrote:

> Jens Axboe <axboe@kernel.dk> writes:
> 
> >> I have applied the first one, will look over the second one and hand
> >> apply it. Seems the NULL return was completely removed, so we _should_
> >> be ok on the IS_ERR() conversion, though that sort of thing always
> >> worries me a little bit. A NULL return can quickly show up again, and
> >> then they would all fail.
> 
> Well, we could guard against that with a BUG_ON in blk_get_request,
> right?

Since the two error cases (ENOMEM and ENODEV) are rare exceptions,
could the reintroduction of a NULL return slip by a quick bench test?

> > Additionally, there's still quite a few places that call
> > blk_get_request() and don't check the error return if __GFP_WAIT is set.
> > Since most of the point of this is to fix segfaulting on queue dead
> > scenarios, why aren't they all converted?
> 
> Odd, I thought they all were converted last I checked.  They definitely
> should be.

I largely left the ide-*.c files alone.  The only guy who bothered
checking the blk_get_request return was ide-park, which I updated with
IS_ERR.  If the others should be hardened (I assumed these were mostly
deprecated drivers), I can add that code in a v3.

Jens, were there other callers that were missed?  I'm using cscope to
find them, so perhaps I inadvertently filtered a file out of the search.

Regards,

-- Joe
