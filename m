Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3LNLPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 06:15:22 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:53920 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab3LNLPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 06:15:21 -0500
Date: Sat, 14 Dec 2013 13:15:15 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Peter Hurley <peter@hurleysoftware.com>
cc: Christoph Lameter <cl@linux.com>, Ethan Zhao <ethan.kernel@gmail.com>,
        alokk@calsoftinc.com, shobhit@calsoftinc.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/slab.c: check pointer slabp before using it in
 alloc_slabmgmt()
In-Reply-To: <52A73EF9.4050105@hurleysoftware.com>
Message-ID: <alpine.SOC.1.00.1312141310250.28548@math.ut.ee>
References: <1386495533-413-1-git-send-email-ethan.kernel@gmail.com> <00000142d82085d4-edeac9e1-d603-458f-9ceb-904e2b706679-000000@email.amazonses.com> <CABawtvPdQ2smcawTywp605KceKAQF+CsvpBqG1zEaKfP-PLB6A@mail.gmail.com> <CABawtvM6MpwHH7kFjnqSr69QWboFXsEiu6Fv0MMJkhQbaXCLxw@mail.gmail.com>
 <00000142dd262a23-776dfc34-c3e4-4229-8684-d99131a2f758-000000@email.amazonses.com> <52A73EF9.4050105@hurleysoftware.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Tue, 10 Dec 2013, Ethan Zhao wrote:
> > 
> > >       No, stable 3.12.4 and 3.12.3 need this patch.  3.13RC doesn't
> > > need it anymore.
> > 
> > Hmmm.. Then this commit may have fixed it:
> 
> Cross-threaded from [Re: Slab BUG with DEBUG_* options ]
> 
> On 12/08/2013 10:00 AM, Meelis Roos wrote:
> > ldata alloc change + your second slab patch + slab debug: hang on boot
> > after
> > console [tty0] enabled, bootconsole disabled
> > (after that, I should see all the dmesg again on serial but I do not).
> 
> Meelis,
> 
> Please grab this patch below and see if it fixes your 'hang on boot'
> with Christoph's other slab patch + slab debug.

Tried it on top of 3.12 + second slab patch + ldata alloc change, and 
lsab debug conf. No change - still hangs on boot.

-- 
Meelis Roos (mroos@linux.ee)
