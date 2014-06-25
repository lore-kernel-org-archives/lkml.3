Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaFYUDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:03:38 -0400
Received: from mailsec109.isp.belgacom.be ([195.238.20.105]:48612 "EHLO
	mailsec109.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbaFYUDh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:03:37 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=hrMHww2J628ocjRUNFs3+6iRWpMu/XOKFNGLEpm+GMs= c=1 sm=2
 a=GiGEYH1j2gIA:10 a=IkcTkHD0fZMA:10 a=LCqXdekRAAAA:8
 a=V68G2WrADEM0UCLtYHkA:9 a=QEXdDO2ut3YA:10 a=IlL50OqVX4wA:10
 a=kg13SUJnC57vgy3Y:21 a=ynMhTyXUDK5GWuln:21
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4GAMwqq1PD7hTT/2dsb2JhbABZgw1Sg0enJQZPAQGYaQGBDhZ1hAMBAQQBIwQiMAULBQYOCgICGA4CAlcGARIRiCkMpRSGf5cpF4EqhDmIZjMHgneBTAWuPINEOw
Date: Wed, 25 Jun 2014 22:03:26 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Bob Copeland <me@bobcopeland.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <810210906.61891.1403726606049.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140625190250.GB399@localhost>
References: <1403720237-19131-1-git-send-email-fabf@skynet.be> <CA+55aFypOwqaxfMwG5H8QSsRyMrMV7ibW_k5CQdc=EPXYmrfLg@mail.gmail.com> <20140625190250.GB399@localhost>
Subject: Re: [PATCH 1/1] fs/omfs/inode.c: replace count*size kzalloc by
 kcalloc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Le 25 juin 2014 à 21:02, Bob Copeland <me@bobcopeland.com> a écrit :
>
>
> On Wed, Jun 25, 2014 at 11:27:21AM -0700, Linus Torvalds wrote:
> > On Wed, Jun 25, 2014 at 11:17 AM, Fabian Frederick <fabf@skynet.be> wrote:
> > > kcalloc manages count*sizeof overflow.
> >
> > As far as I can tell, any overflow has happened long before, in
> >
> >     bitmap_size = DIV_ROUND_UP(sbi->s_num_blocks, 8);
> >
> > where 'sbi->s_num_blocks' i san u64, and 'bitmap_size' is an 'int'.
> >
> > I don't think the patch is necessarily a bad thing, but I think it
> > might be more important to sanity-check that part instead.
>
> Agreed - even though the FS data structures support 64-bit block
> count, I've never seen an OMFS fs with more than about 2M blocks
> (typical device had 20 gigs w/ 8k blocks).  So it would make
> sense to bail in omfs_fill_super if that number is greater than
> 2^31 or so.
We could use unsigned int for bitmap instead of int or simply u64 ?
 
>
> (I am fine with the kcalloc patch too, though.)

>
> --
> Bob Copeland %% www.bobcopeland.com
