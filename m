Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaJ1Ko6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:44:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35611 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbaJ1Koz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:44:55 -0400
Date: Tue, 28 Oct 2014 10:44:52 +0000
From: Steve Capper <steve.capper@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, benh@kernel.crashing.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH V3 1/2] mm: Update generic gup implementation to handle
 hugepage directory
Message-ID: <20141028104451.GB4187@linaro.org>
References: <1414233860-7683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20141027160612.b7fd0b1cc9d82faeaa674940@linux-foundation.org>
 <1414459229.31711.0.camel@concordia>
 <20141027183241.a5339085.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027183241.a5339085.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 06:32:41PM -0700, Andrew Morton wrote:
> On Tue, 28 Oct 2014 12:20:29 +1100 Michael Ellerman <mpe@ellerman.id.au> wrote:
> 
> > On Mon, 2014-10-27 at 16:06 -0700, Andrew Morton wrote:
> > > On Sat, 25 Oct 2014 16:14:19 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > > 
> > > > Update generic gup implementation with powerpc specific details.
> > > > On powerpc at pmd level we can have hugepte, normal pmd pointer
> > > > or a pointer to the hugepage directory.
> > > 
> > > I grabbed these.  It would be better if they were merged into the powerpc
> > > tree where they'll get more testing than in linux-next alone.
> >  
> > Fine by me. Can I get an ack from you and/or someone else on CC?
> > 
> 
> Only arm and arm64 use this code.  Steve, could you please look it over
> and check that arm is still happy?

Hi Andrew,
I've tested it and posted some comments on it.

If the arch/arm and arch/arm64 changes are removed and a comment about
an assumption made by the new gup_huge_pte code is added then I'm happy.

Cheers,
-- 
Steve
