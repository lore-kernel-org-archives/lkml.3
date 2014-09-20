Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaITHOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 03:14:14 -0400
Received: from mailsec111.isp.belgacom.be ([195.238.20.107]:49582 "EHLO
	mailsec111.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbaITHON convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 03:14:13 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=Daq5x7peQTZG5JcO7WbcljS9mPiqDMY23hclUajVz3U= c=1 sm=2
 a=7-sIokkr2u0A:10 a=Rw-gbsmgLOMA:10 a=IkcTkHD0fZMA:10
 a=CMrfILTmy1Pq4ZzpbDwA:9 a=QEXdDO2ut3YA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwSAM8oHVTD7hTT/2dsb2JhbAAZAUYOgn+BKoMBskkBAQEBAQEGm38BfRYBeYQDAQEBAwEjVgULBQQCGAICGA4CAlcGExGIJQyPfyKcR4Z/jwcYgSyEYYlGMweCeIFTBbJhgyBCOy+CSgEBAQ
Date: Sat, 20 Sep 2014 09:14:11 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <1623224162.140196.1411197251348.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140918204455.GA26995@thunk.org>
References: <1411064974-18304-1-git-send-email-fabf@skynet.be> <20140918204455.GA26995@thunk.org>
Subject: Re: [PATCH 1/1 linux-next] jbd2: Fix sparse context imbalance
 warning
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 18 September 2014 at 22:44 Theodore Ts'o <tytso@mit.edu> wrote:
>
>
> On Thu, Sep 18, 2014 at 08:29:34PM +0200, Fabian Frederick wrote:
> > spin_unlock after spin_lock only.
> >
> > This fixes the following sparse warning:
> > fs/jbd2/transaction.c:1102:20: warning: context imbalance
> > in 'jbd2_journal_get_create_access' - different lock contexts for basic
> > block
> >
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
>
> NAK, this is a case where I think it's better to make the static
> analyzers better.  In any case sparse gives a lot of false positives
> for this particular warning, so adding lines of code to try to shut up
> sparse for every single false positive seems to be a losing
> proposition.
>
> I'll note that these sorts of bugs are much more easily picked up
> using lockdep in any case, so we're probably better of just ignoring
> these sorts of warnings.  Better to let the 0day kernel tester warn
> for new sparse warnings, instead of trying to drive sparse warnings
> down to zero.
>
> Cheers,
>
>                                       - Ted

Thanks a lot for explanation Ted. I didn't see J_ASSERT_JH above which BUG_ON
if b_transaction is not ok.


Regards,
Fabian
