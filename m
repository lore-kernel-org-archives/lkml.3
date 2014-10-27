Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaJ0XDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:03:51 -0400
Received: from mail-bn1bon0063.outbound.protection.outlook.com ([157.56.111.63]:65502
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751515AbaJ0XDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:03:48 -0400
X-Greylist: delayed 945 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2014 19:03:47 EDT
Message-ID: <544ECBB1.2040600@opensource.altera.com>
Date: Mon, 27 Oct 2014 17:48:17 -0500
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <m.chehab@samsung.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@opensource.altera.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: Re: [PATCHv2 0/4] Add Altera peripheral memories to EDAC framework
References: <1413578029-13205-1-git-send-email-tthayer@opensource.altera.com> <544E93F0.3030409@opensource.altera.com> <20141027204307.GB4741@pd.tnic> <544EBA84.7080109@opensource.altera.com> <20141027215908.GC4741@pd.tnic>
In-Reply-To: <20141027215908.GC4741@pd.tnic>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CY1PR09CA0024.namprd09.prod.outlook.com (25.160.223.34) To
 BY2PR03MB127.namprd03.prod.outlook.com (10.242.36.27)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB127;
X-Forefront-PRVS: 0377802854
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(51704005)(51914003)(199003)(189002)(479174003)(24454002)(377454003)(50986999)(92566001)(87266999)(122386002)(92726001)(76176999)(83506001)(86362001)(95666004)(54356999)(97736003)(120916001)(40100003)(85852003)(102836001)(50466002)(42186005)(85306004)(23676002)(65816999)(106356001)(46102003)(20776003)(47776003)(105586002)(21056001)(107046002)(64706001)(59896002)(31966008)(101416001)(99396003)(93886004)(80022003)(76482002)(80316001)(77096002)(65806001)(4396001)(65956001)(66066001)(110136001)(33656002)(87976001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB127;H:[137.57.160.203];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB285;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/27/2014 04:59 PM, Borislav Petkov wrote:
> On Mon, Oct 27, 2014 at 04:35:00PM -0500, Thor Thayer wrote:
>> Should I move the EDAC Device probe and error handling from
>> altera_edac_mgr.c to altera_edac.c? Can I mix the MC and Device models
>> in the same file?
> Right, for basic practical reasons, I'd like to keep all functionality
> pertaining to one hw flavour in one compilation unit/one driver. We can
> always split them later if a compelling reason emerges.
>
> Thanks.
>
OK. I will make the changes.

Would the L2 cache and OCRAM specific functions also be in 
altera_edac.c? Each of these EDAC pieces is independent and can be 
compiled in without the others. I've read that the use of #ifdef's is 
discouraged and having separate files in the Makefile solves that.

Thanks for the clarification.

Thor
