Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3EVOXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:23:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab3EVOXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:23:00 -0400
Date: Wed, 22 May 2013 10:22:52 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522142252.GB1407@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <20130521234016.GB14347@redhat.com>
 <20130521235410.GY29466@dastard>
 <20130522000803.GA19891@redhat.com>
 <20130522001603.GZ29466@dastard>
 <20130522025605.GA29767@redhat.com>
 <20130522040318.GG29466@dastard>
 <20130522041521.GA1837@redhat.com>
 <20130522051243.GH29466@dastard>
 <20130522052938.GA2573@redhat.com>
 <20130522055147.GI29466@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522055147.GI29466@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 03:51:47PM +1000, Dave Chinner wrote:

 > > Tomorrow I'll also try running some older kernels with the same
 > > options to see if it's something new, or an older bug. This is a
 > > new machine, so it may be something that's been around for a
 > > while, and for whatever reason, my other machines don't hit
 > > this.
 > 
 > Another thing that just occurred to me - what compiler are you
 > using?  We had a report last week on #xfs that xfsdump was failing
 > with bad checksums because of link time optimisation (LTO) in
 > gcc-4.8.0. When they turned that off, everything worked fine. So if
 > you are using 4.8.0, perhaps trying a different compiler might be a
 > good idea, too.

Yeah, this is 4.8.0. This box is running F19-beta. 
I managed to shoehorn the gcc-4.7 from f18 on there though.
Bug reproduced instantly, so I think we can rule out compiler.

I ran 3.9 with the same debug options. Seems stable.
I'll do a bisect.

	Dave

