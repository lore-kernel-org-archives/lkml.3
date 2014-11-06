Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaKFIBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:01:23 -0500
Received: from mail-bn1bon0148.outbound.protection.outlook.com ([157.56.111.148]:23785
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750980AbaKFIBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:01:20 -0500
Message-ID: <545B2AC4.3090505@freescale.com>
Date: Thu, 6 Nov 2014 10:01:08 +0200
From: Cristian Stoica <cristian.stoica@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <horia.geanta@freescale.com>, <marex@denx.de>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: caam: fix error reporting
References: <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
	<1415179284-19791-1-git-send-email-cristian.stoica@freescale.com>
 <20141105104332.bdc904792193d714bd9d4951@freescale.com>
In-Reply-To: <20141105104332.bdc904792193d714bd9d4951@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(52044002)(199003)(189002)(377454003)(51704005)(479174003)(81156004)(4396001)(105606002)(59896002)(95666004)(65806001)(46102003)(77156002)(21056001)(102836001)(31966008)(92566001)(62966003)(50466002)(106466001)(107046002)(92726001)(20776003)(65956001)(2201001)(47776003)(97736003)(87266999)(76176999)(36756003)(44976005)(68736004)(23756003)(54356999)(104016003)(19580395003)(84676001)(80316001)(64706001)(6806004)(83506001)(19580405001)(64126003)(120916001)(87936001)(15975445006)(69596002)(15202345003)(50986999)(33656002)(65816999)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB396;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB396;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0387D64A71
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B18196@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim, Herbert,


On 11/05/2014 06:43 PM, Kim Phillips wrote:
> On Wed, 5 Nov 2014 11:21:24 +0200
> Cristian Stoica <cristian.stoica@freescale.com> wrote:
> 
>> The error code returned by hardware is four bits wide with an expected
>> zero MSB. A hardware error condition where the error code can get between
>> 0x8 and 0xf will trigger an out of bound array access on the error
>> message table.
>> This patch fixes the invalid array access following such an error and
>> reports the condition.
>>
>> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
>> ---

> no v2 change info?  All I noticed is the additional string for
> "queue manager interface", which, without its implementation fn,

Yes. Thanks for review. That and the updated comment.

> intoduces an inconsistency wrt NULL checking, so this comment:

No. There is no inconsistency in the handling. Please be more specific.

> 
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg12105.html
>
> still applies.

Which comment? You refer to a whole email. My rebutal still applies
though and I think your version is inferior wrt handling the issue.

Feel free to send a competing patch for review though.

Herbert, consider that without a fix one way or another, there is a
potential kernel attack vector through the error reporting function of
the caam driver.


Cristian S.
