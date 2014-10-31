Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbaJaPDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:03:10 -0400
Received: from mail-bn1on0078.outbound.protection.outlook.com ([157.56.110.78]:58781
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933204AbaJaPDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:03:07 -0400
Message-ID: <5453A3C0.70001@opensource.altera.com>
Date: Fri, 31 Oct 2014 09:59:12 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <paulz@synopsys.com>, <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 2/8] usb: dwc2: Move gadget probe function into platform
 code
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com> <1414538749-14735-3-git-send-email-dinguyen@opensource.altera.com> <20141030135740.GC6482@saruman>
In-Reply-To: <20141030135740.GC6482@saruman>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR09CA0051.namprd09.prod.outlook.com (10.255.214.179) To
 BY1PR0301MB1192.namprd03.prod.outlook.com (25.160.195.150)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(51704005)(199003)(164054003)(189002)(479174003)(24454002)(377454003)(122386002)(95666004)(23746002)(54356999)(86362001)(19580395003)(92566001)(575784001)(83506001)(92726001)(50986999)(76176999)(42186005)(120916001)(65816999)(102836001)(50466002)(77096003)(77156002)(64126003)(97736003)(105586002)(40100003)(47776003)(21056001)(107046002)(64706001)(31966008)(2351001)(101416001)(110136001)(46102003)(87976001)(65806001)(106356001)(20776003)(65956001)(66066001)(4396001)(33656002)(19580405001)(99396003)(62966003)(19627235001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1192;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/30/2014 08:57 AM, Felipe Balbi wrote:
> On Tue, Oct 28, 2014 at 06:25:43PM -0500,
> dinguyen@opensource.altera.com wrote:
>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>> 
>> This patch will aggregate the probing of gadget/hcd driver into
>> platform.c. The gadget probe funtion is converted into
>> gadget_init that is now only responsible for gadget only
>> initialization. All the gadget resources is now
> 
> s/resources is/resources are
> 
>> handled by platform.c
>> 
>> Since the host workqueue will not get initialized if the driver
>> is configured for peripheral mode only. Thus we need to check for
>> wq_otg before calling queue_work().
> 
> this period character in the middle of the sentence doesn't make
> sense, perhaps a comma is what you want ? The sentence can be
> improved too:
> 
> "Since the host workqueue will not get initialized if the drier is 
> configured for peripheral mode only, we add a check for wq_otg
> before calling queue_work()."
> 
>> Also, we move spin_lock_init to common location for both host and
>> gadget that is either in platform.c or pci.c.
>> 
>> We also ove suspend/resume code to common platform code, and
>> update it to use the new PM API (struct dev_pm_ops).
> 
> updating to dev_pm_ops should really be a separate patch.
> 

All fixed...

Thanks,
Dinh
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJUU6PAAAoJEBmUBAuBoyj0KJUP/RWpP9YkctpmZQgrb2xq0JaG
eLCpOnKVYaTBCAhydJOKBBx0odYyxORlxTWbJCbZPvPhrZ7NDTINqEVWJOqYmtqe
Xl8aEPYm+ckcfTliONK3yIP/MA49he/qbGOmqXFwFMbcAvKFN/kpq05cjzZ6T8bO
hILDO2Yy2HVQHonq3uKppmTB9DSnCNfCR0Cuum2fpOzmVLY/X46EM5UD2e+XmVgo
dsINAGe40FwFIoLZzAradn12MrmCjOM6MPpkkGZ3SMGjKXY7yQX38c9WbcCvsm6g
y1/5fDqdRlsq+Weoo9N3H03LUX8MlGCpZ7dgLrABXMEjdySj3eVTj4bHgPxRjRY/
+SfI2YR8RyEcHj2UTqgMUp4JmRl2CNiB9fsvZHMQQm2MTeFkcUpZnSUXWHB9Vtwv
s1I5nMOSoT2NDBg6QS9a1T1s1gdSywOnDBd+/SK7mf4QkQumvf2Nvu6avQB1Rxxm
sqpGWztuhuycg332CXc9W0EBXcg5t8SRyk9SFgksH3MezS85gAQxZtXyv44NuCUM
ciTru8tKh3ncszws2NmX9yyQgC4fM3kHDytOwDXFt23f3xHyjg+2m3O1TLErAwig
yqj2MfYTfqfYVrs/hOvOpEbUgUSy5MQY/EOMIsI6aGfB2Nba72wrYQP79ugb84u9
Ftd1XH47lvXX/R8VOV2x
=ZAkf
-----END PGP SIGNATURE-----
