Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaKDRRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:17:42 -0500
Received: from mail-by2on0122.outbound.protection.outlook.com ([207.46.100.122]:11159
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751017AbaKDRRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:17:39 -0500
Date: Tue, 4 Nov 2014 10:57:31 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Cristian Stoica <cristian.stoica@freescale.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <horia.geanta@freescale.com>, <marex@denx.de>
Subject: Re: [PATCH] crypto: caam: fix error reporting
Message-ID: <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
In-Reply-To: <54589515.2010903@freescale.com>
References: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
	<20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
	<5457486C.3030205@freescale.com>
	<20141103134716.775acd39d6334c6f8aeca151@freescale.com>
	<54589515.2010903@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(24454002)(199003)(189002)(51704005)(4396001)(105606002)(47776003)(20776003)(64706001)(93916002)(95666004)(46102003)(104166001)(93886004)(86362001)(92726001)(31966008)(77156002)(50226001)(92566001)(62966003)(21056001)(106466001)(102836001)(50466002)(107046002)(99396003)(23726002)(97736003)(33646002)(100306002)(76176999)(36756003)(110136001)(44976005)(68736004)(84676001)(26826002)(50986999)(46406003)(19580395003)(104016003)(87936001)(88136002)(87286001)(89996001)(6806004)(19580405001)(120916001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB396;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB396;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03853D523D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014 10:57:57 +0200
Cristian Stoica <cristian.stoica@freescale.com> wrote:

> Hi Kim,
> 
> >> Actually, our static code analyzer did not see this one.
> > 
> > ok, so the patch technically isn't fixing anything broken, then.
> 
> Are you saying the code isn't broken _because_ a static tool analyser
> did not see anything wrong here?

no: I'm saying there was no symptom - something I'd expect to gather
from the original commit message.

> > the new code just added a new condition, which doesn't invalidate
> > the comment.  And simply removing the comment as opposed to amending
> > it is a bit overkill.
> 
> You are partially right, but will the staggering lack of comments in the
> caam driver be fixed by duplicating a cascade of three ifs into english?

well, given that preamble, it would be better than removing the
existing two :), but the simpler version makes it a moot point.

> >> It is indeed simpler but does it consider also the missing error codes
> >> at index 1 and 5? Just checking for an upper bound is not enough.
> >
> > no, the existing code already handles that.  Note that newer
> > documentation fills the 1 and 5 slots, too.
> 
> If you have the new error codes please send them to me for an update.

surely you have access to the documentation, if not, let me know.

> >> On the other hand, if the error field is only three bits wide instead of
> >> four as stated by the documentation, a better fix means using a three
> >> bit mask instead of reporting an invalid error code.
> > 
> > true, but then we'd introduce a direct discrepancy with the
> > documentation, and thus h/w.
> 
> You basically ask me to agree that if there are no _documented_ error
> codes between 0x8 and 0xf then I should trust that they will never come
> up on a 4 bit field.

they may, depending on future revs of the h/w, but that's not what
this patch is about.

> Do you want me to drop the patch and pretend there is nothing to see?

no, fixing potential bugs preemptively is fine; I'd just like to
know that's the case: it wasn't clear from the original commit
message whether the problem occurred on a new h/w revision, in which
case I'd have like to have seen the driver updated with support for
the new error codes.

Kim
