Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaKLUPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:15:45 -0500
Received: from ezexch.ezchip.com ([212.179.42.101]:39751 "EHLO ezchip.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753302AbaKLUPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:15:43 -0500
Message-ID: <5463BFE2.4000404@ezchip.com>
Date: Wed, 12 Nov 2014 15:15:30 -0500
From: Chris Metcalf <cmetcalf@ezchip.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <jepler@unpythonic.net>
Subject: Re: [PATCH] arch: tile: kernel: kgdb.c: Use memcpy() instead of pointer
 copy one by one
References: <5454DD70.6060004@gmail.com> <5462C1D3.3010504@gmail.com>
In-Reply-To: <5462C1D3.3010504@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [12.216.194.146]
X-ClientProxiedBy: BLUPR07CA0040.namprd07.prod.outlook.com (10.255.223.153) To
 DB3PR02MB0539.eurprd02.prod.outlook.com (25.160.51.150)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0539;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0539;
X-Forefront-PRVS: 03932714EB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(199003)(24454002)(189002)(479174003)(51704005)(41574002)(46102003)(47776003)(50986999)(54356999)(15202345003)(92726001)(92566001)(23676002)(97736003)(87976001)(87266999)(65816999)(66066001)(65806001)(76176999)(4396001)(21056001)(64706001)(20776003)(42186005)(15975445006)(83506001)(101416001)(102836001)(33656002)(19580405001)(80316001)(19580395003)(86362001)(110136001)(64126003)(36756003)(107046002)(31966008)(105586002)(59896002)(95666004)(122386002)(106356001)(50466002)(62966003)(40100003)(120916001)(77096003)(99396003)(77156002)(18886065003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR02MB0539;H:[10.7.0.239];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0539;
X-OriginatorOrg: ezchip.com
X-TM-AS-Product-Ver: SMEX-11.0.0.1191-7.500.1018-21096.002
X-TM-AS-Result: No--9.537700-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/14 21:17, Chen Gang wrote:
> >Not only memcpy() is faster than pointer copy, but also let code more
> >clearer and simple, which can avoid compiling warning (the original
> >implementation copy registers by exceeding member array border).
> >
> >The related warning (with allmodconfig under tile):
> >
> >     CC      arch/tile/kernel/kgdb.o
> >   arch/tile/kernel/kgdb.c: In function 'sleeping_thread_to_gdb_regs':
> >   arch/tile/kernel/kgdb.c:140:31: warning: iteration 53u invokes undefined behavior [-Waggressive-loop-optimizations]
> >      *(ptr++) = thread_regs->regs[reg];
> >                                  ^
> >   arch/tile/kernel/kgdb.c:139:2: note: containing loop
> >     for (reg = 0; reg <= TREG_LAST_GPR; reg++)
> >     ^
> >
> >Signed-off-by: Chen Gang<gang.chen.5i5j@gmail.com>
> >---
> >  arch/tile/kernel/kgdb.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> >

Taken into the tile tree - thanks!

See my recent email about changing the shape of the pt_regs and sigcontext
structures to make the regs[] usage explicit.  But even with that, I
think your change makes sense to simplify the code in this location.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

