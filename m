Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbbAUGvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:51:11 -0500
Received: from ozlabs.org ([103.22.144.67]:54359 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbbAUGvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:51:09 -0500
Message-ID: <1421823065.23864.1.camel@ellerman.id.au>
Subject: Re: [PATCH V2 06/12] selftests, powerpc: Add test for system wide
 DSCR default
From: Michael Ellerman <mpe@ellerman.id.au>
To: Dave Jones <davej@codemonkey.org.uk>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, anton@samba.org, mikey@neuling.org
Date: Wed, 21 Jan 2015 17:51:05 +1100
In-Reply-To: <20150120214033.GA30240@codemonkey.org.uk>
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
	 <1421144560-15901-7-git-send-email-khandual@linux.vnet.ibm.com>
	 <54B5384F.9010805@osg.samsung.com>
	 <1421192671.10748.4.camel@ellerman.id.au>
	 <20150120214033.GA30240@codemonkey.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 16:40 -0500, Dave Jones wrote:
> On Wed, Jan 14, 2015 at 10:44:31AM +1100, Michael Ellerman wrote:
> 
>  > > Also, I would like to see the test results reports using
>  > > kselftest.h - it can be separate patch in the interest of
>  > > getting tests in.
>  > 
>  > Sorry but kselftest.h doesn't do anything useful for us.
>  > 
>  > We have existing test reporting that uses the subunit protocol.
>  > 
>  > I'm happy to convert that to TAP, or some other well defined output format, but
>  > not to something ad-hoc like kselftest.h currently provides.
> 
> Something TAP-alike would also help reduce some of the spew from
> tests that are going to fail.

Possibly :)
 
> eg, running execveat tests on a kernel that doesn't implement that
> syscall currently spews around 20 lines of [FAIL].  Adding something
> to the beginning of the test to set plan() accordingly if it detects
> -ENOSYS could make that output a little cleaner.

Yeah I'm a bit dubious about plan, it often ends up being a pain to calculate
correctly and so it's either missing or wrong.

The execveat test probably just needs an initial test that looks for ENOSYS and
bails entirely. I'll write a patch.

> That other projects (like jenkins, bug trackers etc) could consume
> the output of the test runs would be a nice bonus.  I only recently
> started looking at kselftests and was surprised at the amount
> of variance we have in the way of printing 'Ok' '[OK]' 'ok...' etc.

Variance in output is annoying, but putting up too many barriers to entry for
new tests is even less desirable IMHO. Our preference should always be for more
tests in the tree, and we can clean up the output/reporting later.

cheers


