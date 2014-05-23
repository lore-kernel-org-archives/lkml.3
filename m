Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaEWGnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 02:43:50 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:27535
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751991AbaEWGns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 02:43:48 -0400
X-Greylist: delayed 872 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 May 2014 02:43:48 EDT
Message-ID: <537EEAA6.7000506@freescale.com>
Date: Fri, 23 May 2014 09:28:54 +0300
From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Lei Xu <Lei.Xu@freescale.com>, Sandeep Malik <Sandeep.Malik@freescale.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC ipsec-next] xfrm: make sha256 icv truncation length RFC-compliant
References: <1400771437-14096-1-git-send-email-horia.geanta@freescale.com>
 <1400771437-14096-2-git-send-email-horia.geanta@freescale.com>
 <537E1FD8.8030504@6wind.com>
In-Reply-To: <537E1FD8.8030504@6wind.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(164054003)(189002)(199002)(377454003)(479174003)(51704005)(19580405001)(44976005)(85852003)(99396002)(20776003)(65816999)(36756003)(83072002)(80022001)(23676002)(77982001)(46102001)(26826002)(59896001)(76482001)(15975445006)(54356999)(87936001)(47776003)(83322001)(50466002)(74502001)(64706001)(50986999)(4396001)(77096999)(21056001)(6806004)(74662001)(81342001)(81542001)(65806001)(79102001)(102836001)(87266999)(92726001)(85182001)(86362001)(92566001)(83506001)(64126003)(31966008)(65956001)(80316001)(33656002)(19580395003)(76176999);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB373;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:gate-az5.freescale.com;MX:1;A:3;LANG:en;
X-Forefront-PRVS: 0220D4B98D
Authentication-Results: spf=fail (sender IP is 192.88.158.246)
 smtp.mailfrom=Horia.Geanta@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/2014 7:03 PM, Nicolas Dichtel wrote:
> Le 22/05/2014 17:10, Horia Geanta a écrit :
>> From: Lei Xu <Lei.Xu@freescale.com>
>>
>> Currently the sha256 icv truncation length is set to 96bit
>> while the length is defined as 128bit in RFC4868.
>> This may result in somer errors when working with other IPsec devices
>> with the standard truncation length.
>> Thus, change the sha256 truncation length from 96bit to 128bit.
> The patch was already proposed, but it was kept as-is for userspace
> compatibility.
>
> See: https://lkml.org/lkml/2012/3/7/431

Thanks, somehow I missed that.

So this just means bad luck for user space tools (for e.g. ipsec-tools - 
setkey, racoon - and any other PF_KEY-based tool) that AFAICT cannot 
override the default truncated icv size, right?

Thanks,
Horia


