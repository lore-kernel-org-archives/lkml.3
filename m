Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaBJRSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:18:22 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:8303
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbaBJRST convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:18:19 -0500
X-Forefront-Antispam-Report: CIP:157.56.240.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0510HT001.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z579ehzbb2dI98dI9371I542I1432I1418Ic84fmzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2fh109h2a8h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah224fh1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh1fe8h1ff5h2216h22d0h2336h2461h2487h24d7h2516h2545h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(377454003)(51444003)(199002)(13464003)(189002)(24454002)(479174003)(53806001)(76482001)(69226001)(46102001)(47446002)(54356001)(51856001)(94316002)(31966008)(81686001)(74502001)(56776001)(54316002)(92566001)(76786001)(76796001)(85852003)(83072002)(83322001)(19580395003)(19580405001)(80976001)(86362001)(94946001)(81542001)(95416001)(81342001)(85306002)(93516002)(95666001)(90146001)(81816001)(74662001)(33646001)(56816005)(93136001)(74876001)(74706001)(59766001)(87936001)(2656002)(76576001)(77096001)(74316001)(4396001)(77982001)(74366001)(65816001)(63696002)(80022001)(47976001)(47736001)(49866001)(50986001)(66066001)(79102001)(87266001)(512794003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO1PR05MB523;H:CO1PR05MB523.namprd05.prod.outlook.com;CLIP:66.129.239.10;FPR:70C9D392.2800AED9.D5599D95.D0E61BCC.2028C;InfoNoRecordsA:1;MX:1;LANG:en;
From: Guenter Roeck <groeck@juniper.net>
To: "monstr@monstr.eu" <monstr@monstr.eu>, Guenter Roeck <linux@roeck-us.net>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 01/10] watchdog: xilinx: Convert driver to the watchdog
 framework
Thread-Topic: [PATCH 01/10] watchdog: xilinx: Convert driver to the watchdog
 framework
Thread-Index: AQHPJoIa3IQvrWI+wUWYQjWBpmCbXZquuOlg
Date: Mon, 10 Feb 2014 17:18:11 +0000
Message-ID: <c5f221694e2041519cabeef0b7552aac@CO1PR05MB523.namprd05.prod.outlook.com>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
 <52F7DF2F.5060001@roeck-us.net> <52F879CF.8080906@monstr.eu>
In-Reply-To: <52F879CF.8080906@monstr.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.239.10]
x-forefront-prvs: 0118CD8765
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Michal Simek [mailto:monstr@monstr.eu]
> Sent: Sunday, February 09, 2014 11:04 PM
> To: Guenter Roeck
> Cc: Michal Simek; linux-kernel@vger.kernel.org; Wim Van Sebroeck;
> linux-watchdog@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 01/10] watchdog: xilinx: Convert driver to the
> watchdog framework
> 
> On 02/09/2014 09:03 PM, Guenter Roeck wrote:
> > On 01/31/2014 06:18 AM, Michal Simek wrote:
> >> - Remove uneeded headers, fops functions
> >> - Use xilinx_wdt prefix in start/stop/keepalive functions
> >>    and in new structures
> >>
> >> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> >
> > Hi Michal,
> >
> >>   static int xwdt_probe(struct platform_device *pdev)
> >>   {
> >>       int rc;
> >> @@ -314,7 +184,7 @@ static int xwdt_probe(struct platform_device
> *pdev)
> >>                       "xlnx,wdt-enable-once", NULL);
> >>       if (tmptr == NULL) {
> >>           pr_warn("Parameter \"xlnx,wdt-enable-once\" not found in
> device tree!\n");
> >> -        xdev.nowayout = WATCHDOG_NOWAYOUT;
> >> +        watchdog_set_nowayout(&xilinx_wdt_wdd, true);
> >
> > Sure you want to set this to always true instead of using
> WATCHDOG_NOWAYOUT ?
> 
> I have checked it and
> option CONFIG_WATCHDOG_NOWAYOUT - Disable watchdog shutdown on close
> 
> with this part in the header
> 
> 100 #ifdef CONFIG_WATCHDOG_NOWAYOUT
> 101 #define WATCHDOG_NOWAYOUT               1
> 102 #define WATCHDOG_NOWAYOUT_INIT_STATUS   (1 << WDOG_NO_WAY_OUT)
> 103 #else
> 104 #define WATCHDOG_NOWAYOUT               0
> 105 #define WATCHDOG_NOWAYOUT_INIT_STATUS   0
> 106 #endif
> 
> enable once is hardware option and it means when this option is setup
> in hw you can't stop watchdog. That's why I think that setting up true
> instead of WATCHDOG_NOWAYOUT is correct.
> 

Ok, makes sense.

Guenter


