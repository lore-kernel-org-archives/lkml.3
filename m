Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbaISO3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:29:48 -0400
Received: from mail-by2on0057.outbound.protection.outlook.com ([207.46.100.57]:10953
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754306AbaISO3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:29:46 -0400
Message-ID: <541C3DD2.9030501@opensource.altera.com>
Date: Fri, 19 Sep 2014 09:29:38 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: <paulz@synopsys.com>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 08/12] usb: dwc2: gadget: Do not fail probe if there
 isn't a clock node
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com> <1409070003-21195-9-git-send-email-dinguyen@opensource.altera.com> <3825627.ZuOPzBNWiB@amdc1032>
In-Reply-To: <3825627.ZuOPzBNWiB@amdc1032>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: BLUPR08CA0042.namprd08.prod.outlook.com (10.141.200.22) To
 BN3PR0301MB1185.namprd03.prod.outlook.com (25.160.156.147)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(479174003)(377454003)(24454002)(51704005)(164054003)(199003)(83506001)(50466002)(105586002)(21056001)(42186005)(50986999)(77096002)(102836001)(19580395003)(99396002)(87976001)(76482002)(95666004)(83322001)(110136001)(80316001)(19580405001)(106356001)(47776003)(92566001)(20776003)(92726001)(107046002)(65806001)(31966008)(65956001)(66066001)(97736003)(4396001)(54356999)(76176999)(90102001)(65816999)(87266999)(33656002)(59896002)(85852003)(86362001)(85306004)(23756003)(79102003)(101416001)(64126003)(74662003)(81542003)(46102003)(83072002)(77982003)(74502003)(80022003)(81342003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1185;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 9/12/14, 11:28 AM, Bartlomiej Zolnierkiewicz wrote:
> 
> [ added linux-kernel ML to cc: ]
> 
> Hi,
> 
> On Tuesday, August 26, 2014 11:19:59 AM dinguyen@opensource.altera.com wrote:
>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>>
>> Since the dwc2 hcd driver is currently not looking for a clock node during
>> init, we should not completely fail if there isn't a clock provided.
>> Add a check for a valid clock before calling clock functions.
> 
> This doesn't look correct at least for the case when we are really missing
> the clock and USB_DWC2_PERIPHERAL=y (moreover it just looks wrong to access
> gadget functionalities when clock is disabled). It seems that it would be
> better to just disable gadget functionality on dwc2_gadget_init() failure
> in hcd and not call gadget functions later from hcd if gadget functionality
> is disabled.
> 

Yes...this is correct. Will fix up in v5.

Thanks,
Dinh
