Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbbAUQ5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:57:16 -0500
Received: from mail-db3on0054.outbound.protection.outlook.com ([157.55.234.54]:4672
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754925AbbAUQ4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:56:40 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
From: Andri Yngvason <andri.yngvason@marel.com>
In-Reply-To: <20150121153647.GB17070@linux>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20141223154654.GB6460@vivalin-002> <20150120214409.GA16828@linux>
 <20150120214537.GB16828@linux> <20150121103319.14511.57709@shannon>
 <e5439ed067931dc01bda70592eb6ed52@grandegger.com>
 <20150121144323.GA17070@linux> <20150121150015.31351.6605@shannon>
 <20150121153647.GB17070@linux>
Message-ID: <20150121163753.2933.88876@shannon>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 2/5] can: kvaser_usb: Consolidate and unify state change
 handling
Date: Wed, 21 Jan 2015 16:37:53 +0000
X-Originating-IP: [10.100.11.118]
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 212.30.206.5)
 smtp.mailfrom=Andri.Yngvason@marel.com; 
X-Forefront-Antispam-Report: CIP:212.30.206.5;CTRY:IS;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(199003)(24454002)(51704005)(377424004)(57986006)(50466002)(106466001)(6806004)(46102003)(71226002)(76506005)(87936001)(110136001)(64706001)(47776003)(88526003)(33716001)(92566002)(54356999)(76176999)(86362001)(77156002)(16796002)(77096005)(83506001)(23676002)(93886004)(50986999)(2950100001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR05MB0825;H:smtp.marel.com;FPR:;SPF:Pass;MLV:sfv;PTR:smtp.marel.com;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DB3PR05MB0825;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB3PR05MB0825;
X-Forefront-PRVS: 04631F8F77
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB0825;
X-OriginatorOrg: marel.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2015 16:37:54.9838
 (UTC)
X-MS-Exchange-CrossTenant-Id: e5f498be-7303-45fd-a594-9e3fd22a77d7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5f498be-7303-45fd-a594-9e3fd22a77d7;Ip=[212.30.206.5]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR05MB0825
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ahmed S. Darwish (2015-01-21 15:36:47)
> On Wed, Jan 21, 2015 at 03:00:15PM +0000, Andri Yngvason wrote:
> > Quoting Ahmed S. Darwish (2015-01-21 14:43:23)
> > > Hi!
> 
> ...
> 
> > > <-- Unplug the cable -->
> > > 
> > >  (000.009106)  can0  20000080   [8]  00 00 00 00 00 00 08 00   ERRORFRAME
> > >         bus-error
> > >         error-counter-tx-rx{{8}{0}}
> > >  (000.001872)  can0  20000080   [8]  00 00 00 00 00 00 10 00   ERRORFRAME
> > >         bus-error
> > >         error-counter-tx-rx{{16}{0}}
> > [...]
> > >         error-counter-tx-rx{{80}{0}}
> > >  (000.001910)  can0  20000080   [8]  00 00 00 00 00 00 58 00   ERRORFRAME
> > >         bus-error
> > >         error-counter-tx-rx{{88}{0}}
> > >  (000.001753)  can0  20000084   [8]  00 08 00 00 00 00 60 00   ERRORFRAME
> > >         controller-problem{tx-error-warning}
> > Good.
> > >         bus-error
> > >         error-counter-tx-rx{{96}{0}}
> 
> Nice.
> 
> > >  (000.001720)  can0  20000080   [8]  00 00 00 00 00 00 68 00   ERRORFRAME
> > >         bus-error
> > >         error-counter-tx-rx{{104}{0}}
> > >  (000.001876)  can0  20000080   [8]  00 00 00 00 00 00 70 00   ERRORFRAME
> > >         bus-error
> > >         error-counter-tx-rx{{112}{0}}
> > >  (000.001749)  can0  20000080   [8]  00 00 00 00 00 00 78 00   ERRORFRAME
> > >         bus-error
> > >         error-counter-tx-rx{{120}{0}}
> > >  (000.001771)  can0  20000084   [8]  00 20 00 00 00 00 80 00   ERRORFRAME
> > >         controller-problem{tx-error-passive}
> > Also good.
> > >         bus-error
> > >         error-counter-tx-rx{{128}{0}}
> 
> Also nice :-)
> 
> > >  (000.001868)  can0  20000080   [8]  00 00 00 00 00 00 80 00   ERRORFRAME
> > >         bus-error
> > >         error-counter-tx-rx{{128}{0}}
> > >  (000.001982)  can0  20000080   [8]  00 00 00 00 00 00 80 00   ERRORFRAME
> > >         bus-error
> > >         error-counter-tx-rx{{128}{0}}
> > > 
> > > (( Then a continous flood, exactly similar to the above packet, appears.
> > >    Unfortunately this flooding is a firmware problem. ))
> > > 
> > > <-- Replug the cable, after a good amount of time -->
> > >
> > Where are the reverse state transitions?
> > > 
> 
> Hmmm...
> 
> [ ... ]
> > 
> > Reverse state transitions are missing from the logs. See comments above.
> > 
> 
> When the device is on the _receiving_ end, and I unplug the CAN cable after
> introducing some noise to the level of reaching WARNING or PASSIVE, I
> receive a BUS_ERROR event with the rxerr count reset back to 0 or 1. In
> that case, the driver correctly transitions back the state to ERROR_ACTIVE
> and candump produces something similar to:
> 
>     (000.000362)  can0  2000008C   [8]  00 40 40 00 00 00 00 01   ERRORFRAME
>     controller-problem{}
>     protocol-violation{{back-to-error-active}{}}
>     bus-error
>     error-counter-tx-rx{{0}{1}}
> 
> which is, AFAIK, the correct behaviour from the driver side.
> 
> Meanwhile, when the device is on the _sending_ end and I re-plug the CAN
> cable again. Sometimes I receive events with txerr reset to 0 or 1, and
> the driver correctly reverts back to ERROR_ACTIVE in that case. But on
> another times like the quoted case above, I don't receive any events
> resetting txerr back -- only data packets on the bus.
> 
> So, What can the driver do given the above?
>
So what you're telling us is that the state does not got back to error-active
unless there is something else transmitting on the bus?
If that's the case, it's almost definitely because state changes aren't
triggering interrupts.

An rx event will give you an interrupt which yields a napi poll which means that
the state will be polled, so in that case you don't need the interrupts.

Look for "Consolidate and unify state change handling" on gmane. There was a lot
of discussion about this kind of issues, especially regarding FlexCAN.

Best regards,
Andri
