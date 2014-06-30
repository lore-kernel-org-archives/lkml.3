Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaF3Nvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:51:42 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:23131
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750897AbaF3Nvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:51:40 -0400
Message-ID: <53B16B46.7060101@freescale.com>
Date: Mon, 30 Jun 2014 16:51:02 +0300
From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/kernel-doc: handle object-like macros
References: <1403525732-7653-1-git-send-email-horia.geanta@freescale.com>
 <53AF7F63.9080807@infradead.org>
In-Reply-To: <53AF7F63.9080807@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(24454002)(164054003)(189002)(199002)(377454003)(479174003)(85852003)(83072002)(92566001)(77982001)(97736001)(99396002)(65806001)(105606002)(80022001)(50986999)(76176999)(54356999)(64126003)(79102001)(65956001)(87266999)(81542001)(85182001)(23676002)(95666004)(4396001)(21056001)(86362001)(83506001)(87936001)(104016002)(19580395003)(85306003)(31966008)(74662001)(69596002)(47776003)(81156004)(106466001)(102836001)(81342001)(80316001)(15975445006)(92726001)(26826002)(84676001)(46102001)(33656002)(65816999)(76482001)(59896001)(36756003)(64706001)(44976005)(83322001)(50466002)(20776003)(107046002)(68736004)(74502001)(6806004);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB390;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0258E7CCD4
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Horia.Geanta@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/2014 5:52 AM, Randy Dunlap wrote:
> On 06/23/14 05:15, Horia Geanta wrote:
>> Object-like macros are different than function-like macros:
>> https://gcc.gnu.org/onlinedocs/cpp/Object-like-Macros.html
>> https://gcc.gnu.org/onlinedocs/cpp/Function-like-Macros.html
>>
>> They are not parsed correctly, generating invalid intermediate
>> files (xmls) for cases like:
>>      #define BIT_MASK    (0xFF << BIT_SHIFT)
>> where "OxFF <<" is considered to be parameter type.
>>
>> When parsing, we can differentiate beween these two types of macros by

                                      between.

>> checking whether there is at least one whitespace b/w "#define" and
>> first opening paranthesis.
>
>                  parenthesis.

Thanks, I'll fix both typos in v2.

>
> Where did you see a problem?  I tested the patch and all of the
> Documentation/DocBook/*.xml files are the same without or with the patch.
>

Indeed, right now there is no kernel-doc for "object-like" macros in 
Docbook.

I am preparing documentation for not-yet-upstreamed code in 
drivers/crypto/caam and I thought it would be useful to use kernel-doc 
for some of the #defines.

Doc would look like this (no @param list, no "Return" section, only a 
description):

/**
  * DEFAULT_SEC_ERA - the default value for the SEC era in case the user
  * provides an unsupported value.
  */
#define DEFAULT_SEC_ERA 6

Regards,
Horia


