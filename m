Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3LFIS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:18:26 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:34033
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753663Ab3LFISV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:18:21 -0500
X-IronPort-AV: E=Sophos;i="4.93,839,1378850400"; 
   d="scan'208";a="39593222"
Date: Fri, 6 Dec 2013 09:18:17 +0100
From: Martin Quinson <martin.quinson@loria.fr>
To: Christoph Lameter <cl@linux.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Andreas Gruenbacher <agruen@linbit.com>
Subject: Re: quilt 0.60 does not include CCed email without name
Message-ID: <20131206081816.GQ9578@alphonse.loria.fr>
References: <20131203233232.928771708@linux.com>
 <20131203233250.717784556@linux.com>
 <1386115809.2166.126.camel@dabdike.int.hansenpartnership.com>
 <alpine.DEB.2.02.1312051244540.26098@gentwo.org>
 <00000142c48e1f2a-fd398f0b-8726-4cec-a939-2c3a823bff39-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142c48e1f2a-fd398f0b-8726-4cec-a939-2c3a823bff39-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 08:58:37PM +0000, Christoph Lameter wrote:
> > > You say this in the commit, but the linux-parisc list isn't cc'd on the
> > > email ...
> >
> > Weird my testoutput before the patchset was sent out shows that it
> > was included then :
> 
> Ok while the test output was done with quilt 0.50 the patch was actually
> send with quilt 0.60 from another system. quilt 0.60 skips all Cc:s that
> do not have a full name.
> 
> So Helge was included since it had a name
> 
> > Cc: Helge Deller <deller@gmx.de>
> 
> but
> 
> > Cc: linux-parisc@vger.kernel.org
> 
> did not because no name was available.
> 
> Martin?

I'm sorry, I never use the quilt mail command myself. After a quick
investiguation of the git history, this bug seems to be caused by:
http://git.savannah.gnu.org/cgit/quilt.git/commit/?id=02f15444278eb3a854acae0192124153e0c6d9d4

I think that the last lines should be changed as follows (and same for
the one before):
- -e 's/^\('"$*"'\):\(.*<.*@.*>\)/Recipient-Cc:\2/Ip' \
+ -e 's/^\('"$*"'\):\(.*@.*\)/Recipient-Cc:\2/Ip' \

I'm CCing Andreas so that he can comment, and if nobody complains I'll
commit it to our git.

Many thanks for the detailed bug report,
Mt.

-- 
Simplicity does not precede complexity, but follows it.
   -- "Epigrams in Programming", by Alan J. Perlis of Yale University.
