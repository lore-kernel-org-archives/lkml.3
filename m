Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbbANCg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:36:58 -0500
Received: from mail-bn1bon0132.outbound.protection.outlook.com ([157.56.111.132]:15648
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752116AbbANCg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:36:56 -0500
Date: Wed, 14 Jan 2015 09:26:54 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Felipe Balbi <balbi@ti.com>
CC: Kiran Raparthy <kiran.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Subject: Re: [PATCH v3 3/3] usb: phy: hold wakeupsource when USB is
 enumerated in peripheral mode
Message-ID: <20150114012653.GB14944@shlinux2>
References: <1416849900-29959-1-git-send-email-kiran.kumar@linaro.org>
 <1416849900-29959-3-git-send-email-kiran.kumar@linaro.org>
 <15cad5ef7627483cbba96e05fe180813@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <20141125144544.GC6360@saruman>
 <CA+RfmHZRqMwiSAZ7kpn+0_8a+25O+hRKxGJuK6im6fX0dzB8Nw@mail.gmail.com>
 <CA+RfmHb9OQ1Y_c-93jgpWWfNpTNLE84+Z70bOMtNrbJhQSWQAA@mail.gmail.com>
 <20150113161802.GD16533@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150113161802.GD16533@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(51704005)(189002)(77096005)(105606002)(33716001)(62966003)(77156002)(50986999)(50466002)(76176999)(54356999)(2950100001)(104016003)(87936001)(92566002)(97756001)(110136001)(85426001)(81156004)(93886004)(33656002)(69596002)(106466001)(86362001)(23726002)(46102003)(47776003)(64706001)(19580395003)(46406003)(19580405001)(83506001)(6806004);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB329;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR03MB329;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR03MB329;
X-Forefront-PRVS: 04569283F9
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB329;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2015 02:36:52.4931
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR03MB329
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 10:18:02AM -0600, Felipe Balbi wrote:
> On Tue, Jan 13, 2015 at 04:02:20PM +0530, Kiran Raparthy wrote:
> > Hi Felipe,
> > 
> > On 1 December 2014 at 11:09, Kiran Raparthy <kiran.kumar@linaro.org> wrote:
> > > Hi Felipe,
> > >
> > > On 25 November 2014 at 20:15, Felipe Balbi <balbi@ti.com> wrote:
> > >> On Tue, Nov 25, 2014 at 07:06:18AM +0000, Peter Chen wrote:
> > >>>
> > >>> >
> > >>> > usb: phy: hold wakeupsource when USB is enumerated in peripheral mode
> > >>> >
> > >>> > Some systems require a mechanism to prevent system to enter into suspend
> > >>> > state when USB is connected and enumerated in peripheral mode.
> > >>> >
> > >>> > This patch provides an interface to hold a wakeupsource to prevent suspend.
> > >>> > PHY drivers can use this interface when USB is connected and enumerated in
> > >>> > peripheral mode.
> > >>> >
> > >>> > A timed wakeupsource is temporarily held on USB disconnect events, to allow
> > >>> > the rest of the system to react to the USB disconnection (dropping host
> > >>> > sessions, updating charger status, etc.) prior to re-allowing suspend.
> > >>> >
> > >>>
> > >>> Hi Kiran & Felipe,
> > >>>
> > >>> Just two questions for this series
> > >>>
> > >>> - Will it be the default behavior for all peripheral drivers?
> > >>> - If the peripheral driver's PHY driver does not vbus event, how to
> > >>> support it?
> > >>> For example, chipidea udc driver has its vbus interface at its
> > >>> controller register.
> > >>
> > >> hmm, good point. Since it's so late, I'll just go ahead and drop
> > >> $subject from v3.20. Let's delay only $subject to v3.20 merge window so
> > >> we have some more time to discuss these details.
> > >
> > > I am just curious to know/understand why this feature needs to be
> > > default behavior for all peripheral drivers?
> > > If this needs to be default behavior, could you please suggest any
> > > alternate plan/design for this feature so that i can incorporate them
> > > in new patch.
> > > Regards,
> > > Kiran
> > 
> > Just a gentle reminder to consider the patch.
> 
> sorry, for the delay... man this release round has been hectic. We still
> haven't sorted out what should be the default behavior here, considering
> some PHYs will not be able to report VBUS levels, I'm not sure what we
> should do here.
> 

My opinion is: if we need this feature, we should depend on gadget's
state, eg 'configured', not vbus level. The system suspend should be
allowed if the gadget state is 'suspended' which vbus is still there.

-- 

Best Regards,
Peter Chen
