Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaFFNVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:21:52 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:36501
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751675AbaFFNVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:21:50 -0400
X-WSS-ID: 0N6R147-07-AU7-02
X-M-MSG: 
Message-ID: <5391C063.3010207@amd.com>
Date: Fri, 6 Jun 2014 08:21:39 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
References: <20140606164543.6c5bbe67@canb.auug.org.au>
In-Reply-To: <20140606164543.6c5bbe67@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(479174003)(377454003)(51704005)(53754006)(24454002)(189002)(199002)(86362001)(46102001)(81542001)(97736001)(81342001)(74502001)(84676001)(23756003)(83072002)(77982001)(85852003)(59896001)(76482001)(31966008)(74662001)(36756003)(79102001)(92566001)(92726001)(99396002)(4396001)(83506001)(21056001)(64706001)(64126003)(101416001)(65806001)(80022001)(65956001)(68736004)(65816999)(76176999)(77096999)(54356999)(87266999)(87936001)(20776003)(44976005)(47776003)(50986999)(50466002)(83322001)(33656002)(102836001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 023495660C
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 01:45 AM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the net-next tree, today's linux-next build (powerpc allyesconfig)
> failed like this:
>
>
> drivers/net/ethernet/amd/xgbe/xgbe-dev.c:119:25: fatal error: asm/cputype.h: No such file or directory
>   #include <asm/cputype.h>
>                           ^

I accidentally left this in from driver debugging and it is not
necessary.  Patch to follow.

Tom

>
> Caused by commit c5aa9e3b8156 ("amd-xgbe: Initial AMD 10GbE platform driver").
>
> I reverted commit 54a4ca8e3730 ("Merge branch 'amd-xgbe'") for today.
>
