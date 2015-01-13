Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbbAMXoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:44:34 -0500
Received: from ozlabs.org ([103.22.144.67]:60894 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbAMXod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:44:33 -0500
Message-ID: <1421192671.10748.4.camel@ellerman.id.au>
Subject: Re: [PATCH V2 06/12] selftests, powerpc: Add test for system wide
 DSCR default
From: Michael Ellerman <mpe@ellerman.id.au>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, anton@samba.org, mikey@neuling.org
Date: Wed, 14 Jan 2015 10:44:31 +1100
In-Reply-To: <54B5384F.9010805@osg.samsung.com>
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
	 <1421144560-15901-7-git-send-email-khandual@linux.vnet.ibm.com>
	 <54B5384F.9010805@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 08:22 -0700, Shuah Khan wrote:
> On 01/13/2015 03:22 AM, Anshuman Khandual wrote:
> > This patch adds a test case for the system wide DSCR default
> > value, which when changed through it's sysfs interface must
> > be visible to all threads reading DSCR either through the
> > privilege state SPR or the problem state SPR. The DSCR value
> > change should be immediate as well.
> > 
> > Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> > ---
> >  tools/testing/selftests/powerpc/Makefile           |   2 +-
> >  tools/testing/selftests/powerpc/dscr/Makefile      |  17 +++
> >  tools/testing/selftests/powerpc/dscr/dscr.h        | 120 ++++++++++++++++++++
> >  .../selftests/powerpc/dscr/dscr_default_test.c     | 121 +++++++++++++++++++++
> >  4 files changed, 259 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/powerpc/dscr/Makefile
> >  create mode 100644 tools/testing/selftests/powerpc/dscr/dscr.h
> >  create mode 100644 tools/testing/selftests/powerpc/dscr/dscr_default_test.c
> 
> Could you please add a .gitignore for powerpc targets as we
> discussed earlier. It can be separate patch.

I can do that.
 
> Also, I would like to see the test results reports using
> kselftest.h - it can be separate patch in the interest of
> getting tests in.

Sorry but kselftest.h doesn't do anything useful for us.

We have existing test reporting that uses the subunit protocol.

I'm happy to convert that to TAP, or some other well defined output format, but
not to something ad-hoc like kselftest.h currently provides.

cheers


