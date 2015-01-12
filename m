Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbbALTM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:12:29 -0500
Received: from mail-by2on0082.outbound.protection.outlook.com ([207.46.100.82]:62528
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756785AbbALTM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:12:26 -0500
Message-ID: <54B41BED.5090809@opensource.altera.com>
Date: Mon, 12 Jan 2015 13:09:33 -0600
From: Graham Moore <grmoore@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Tull <atull@opensource.altera.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Yves Vandervennet <yvanderv@opensource.altera.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH V2 2/2] mtd: spi-nor: Bindings for Cadence Quad SPI Flash
 Controller driver.
References: <1420564094-1086-1-git-send-email-grmoore@opensource.altera.com> <1420564094-1086-2-git-send-email-grmoore@opensource.altera.com> <54AD31F8.4050100@vanguardiasur.com.ar> <CAL_Jsq+nbZMnJZ=Wm--DODWRXm5aqEJ_7BVDuET9oSXJaJtWug@mail.gmail.com>
In-Reply-To: <CAL_Jsq+nbZMnJZ=Wm--DODWRXm5aqEJ_7BVDuET9oSXJaJtWug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CO2PR06CA052.namprd06.prod.outlook.com (10.141.242.52) To
 BL2PR03MB433.namprd03.prod.outlook.com (10.141.92.19)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=grmoore@opensource.altera.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BL2PR03MB433;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2PR03MB433;
X-Forefront-PRVS: 0454444834
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(199003)(164054003)(479174004)(377454003)(51704005)(189002)(50986999)(54356999)(66066001)(65956001)(65806001)(50466002)(1411001)(68736005)(77096005)(64706001)(47776003)(64126003)(105586002)(86362001)(93886004)(76176999)(83506001)(19580395003)(2950100001)(46102003)(80316001)(65816999)(40100003)(87976001)(101416001)(97736003)(110136001)(122386002)(23676002)(42186005)(62966003)(551934003)(33656002)(92566002)(77156002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB433;H:[137.57.160.195];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB433;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2015 19:12:21.6463 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2PR03MB433
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/08/2015 04:30 PM, Rob Herring wrote:
>
> This controller only works with flash devices and is different than this one:?
>
> Documentation/devicetree/bindings/spi/spi-cadence.txt
>

Yes, it is a different controller and is for flash only.  The docs call 
it the "QSPI Flash Controller".
...

>
> The above binding already uses "is-decoded-cs". Let's not invent something new.
>

OK.
...

>
>>> +- cdns,tshsl-ns : Delay in master reference clocks for the length that the master mode chip select outputs are de-asserted between transactions.
>>> +- cdns,tsd2d-ns : Delay in master reference clocks between one chip select being de-activated and the activation of another.
>>> +- cdns,tchsh-ns : Delay in master reference clocks between last bit of current transaction and deasserting the device chip select (qspi_n_ss_out).
>>> +- cdns,tslch-ns : Delay in master reference clocks between setting qspi_n_ss_out low and first bit transfer.
>
> Aren't these properties probeable at all? We really should have
> standard bindings for this. It seems spi NOR flash devices have gone
> somewhat undocumented, but it is not hard to find examples already in
> use.
>

They are not probeable, afaik.  I don't see these values in any 
probeable info block in the datasheet, only in the AC params table.

I can't find an example of these timing parameters, do you have one in mind?

> Is it master reference clocks or nanoseconds for the units?

Yeah, they are actually nanoseconds in the dts, converted to clocks in 
the driver.  I'll change the docs.

...

Thanks,
Graham
