Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaKDI6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:58:10 -0500
Received: from mail-bl2on0113.outbound.protection.outlook.com ([65.55.169.113]:52933
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750985AbaKDI6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:58:05 -0500
Message-ID: <54589515.2010903@freescale.com>
Date: Tue, 4 Nov 2014 10:57:57 +0200
From: Cristian Stoica <cristian.stoica@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <horia.geanta@freescale.com>, <marex@denx.de>
Subject: Re: [PATCH] crypto: caam: fix error reporting
References: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
	<20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
	<5457486C.3030205@freescale.com>
 <20141103134716.775acd39d6334c6f8aeca151@freescale.com>
In-Reply-To: <20141103134716.775acd39d6334c6f8aeca151@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(199003)(99136001)(26826002)(117636001)(93886004)(110136001)(84676001)(59896002)(83506001)(104016003)(69596002)(97736003)(77156002)(92566001)(31966008)(102836001)(44976005)(4396001)(92726001)(68736004)(87936001)(50466002)(47776003)(64126003)(23756003)(6806004)(50986999)(65816999)(76176999)(54356999)(65806001)(87266999)(120916001)(64706001)(21056001)(65956001)(99396003)(105606002)(81156004)(46102003)(106466001)(95666004)(107046002)(20776003)(36756003)(62966003)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0706;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0706;
X-Forefront-PRVS: 03853D523D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B18196@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

>> Actually, our static code analyzer did not see this one.
> 
> ok, so the patch technically isn't fixing anything broken, then.

Are you saying the code isn't broken _because_ a static tool analyser
did not see anything wrong here?


> the new code just added a new condition, which doesn't invalidate
> the comment.  And simply removing the comment as opposed to amending
> it is a bit overkill.

You are partially right, but will the staggering lack of comments in the
caam driver be fixed by duplicating a cascade of three ifs into english?


>> It is indeed simpler but does it consider also the missing error codes
>> at index 1 and 5? Just checking for an upper bound is not enough.
>
> no, the existing code already handles that.  Note that newer
> documentation fills the 1 and 5 slots, too.

If you have the new error codes please send them to me for an update.


>> On the other hand, if the error field is only three bits wide instead of
>> four as stated by the documentation, a better fix means using a three
>> bit mask instead of reporting an invalid error code.
> 
> true, but then we'd introduce a direct discrepancy with the
> documentation, and thus h/w.

You basically ask me to agree that if there are no _documented_ error
codes between 0x8 and 0xf then I should trust that they will never come
up on a 4 bit field.

Do you want me to drop the patch and pretend there is nothing to see?


Cristian S.
