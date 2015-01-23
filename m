Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbbAWIYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:24:19 -0500
Received: from mail-bn1bon0085.outbound.protection.outlook.com ([157.56.111.85]:21776
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753667AbbAWIYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:24:17 -0500
Date: Fri, 23 Jan 2015 09:23:39 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Nathan Lynch <Nathan_Lynch@mentor.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <monstr@monstr.eu>,
        Ohad Ben-Cohen <ohad@wizery.com>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?windows-1252?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH 2/2] remoteproc: microblaze: Add support for microblaze
 on Zynq
References: <a458462d2dc6901440bded015608f7a9df9e7942.1421662385.git.michal.simek@xilinx.com>
 <10276362c737fc9da863f1a07737fd91f7340242.1421662385.git.michal.simek@xilinx.com>
 <54C12AF9.40200@mentor.com>
In-Reply-To: <54C12AF9.40200@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21276.002
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <9958fd0fb61347558d33ca92dcc02a88@BN1BFFO11FD005.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; mentor.com; dkim=none (message not
 signed) header.d=none;
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(479174004)(51704005)(24454002)(164054003)(377454003)(64126003)(62966003)(108616004)(92566002)(2950100001)(33646002)(104016003)(77156002)(77096005)(6806004)(92726002)(83506001)(46102003)(54356999)(50986999)(76176999)(86362001)(47776003)(74316001)(50466002)(87936001)(65806001)(23746002)(65956001)(106466001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB005;H:xir-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB005;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1BFFO11HUB005;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB005;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 08:24:05.1063
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[62.221.5.235]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1BFFO11HUB005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 05:53 PM, Nathan Lynch wrote:
> On 01/19/2015 04:30 AM, Michal Simek wrote:
>> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
>> index 5e343bab9458..3955f42e9e9c 100644
>> --- a/drivers/remoteproc/Kconfig
>> +++ b/drivers/remoteproc/Kconfig
>> @@ -64,4 +64,15 @@ config DA8XX_REMOTEPROC
>>  	  It's safe to say n here if you're not interested in multimedia
>>  	  offloading.
>>
>> +config MB_REMOTEPROC
>> +	tristate "Support Microblaze remoteproc"
>> +	depends on ARCH_ZYNQ && !DEBUG_SG
>> +	select GPIO_XILINX
>> +	select REMOTEPROC
>> +	select RPMSG
>> +	default m
>> +	help
>> +	  Say y here to support Xilinx Microblaze remote processors
>> +	  on the Xilinx Zynq.
>> +
>>  endmenu
> 
> The dependency on !DEBUG_SG seems unusual, and worth a comment if it's
> truly needed.  And the module should be disabled by default, no?

Right - I will remove this dependency. It is not needed now.

Using is like a module is good usecase because you can reload SW on remote cpu.

Thanks,
Michal


