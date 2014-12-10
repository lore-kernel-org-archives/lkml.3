Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaLJJT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:19:26 -0500
Received: from mail-by2on0142.outbound.protection.outlook.com ([207.46.100.142]:38176
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751749AbaLJJTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:19:22 -0500
From: Dudley Du <dudl@cypress.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: RE: [PATCH v13 09/12] input: cyapa: add gen5 trackpad device firmware
 update function support
Thread-Topic: [PATCH v13 09/12] input: cyapa: add gen5 trackpad device
 firmware update function support
Thread-Index: AQHQE5EQns/8n0nYEUu4VbDeUYGufZyILN+AgABZ7oCAAAXQAA==
Date: Wed, 10 Dec 2014 09:19:19 +0000
Message-ID: <BN1PR06MB0708DF8CE49D491D55E4F00D1620@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
 <1418116304-11392-10-git-send-email-dudley.dulixin@gmail.com>
 <20141210033303.GA4173@hudson.localdomain>
 <20141210085455.GA7174@hudson.localdomain>
In-Reply-To: <20141210085455.GA7174@hudson.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB071;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB071;
x-forefront-prvs: 0421BF7135
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(199003)(51704005)(13464003)(164054003)(189002)(51164003)(46102003)(64706001)(93886004)(19580405001)(19580395003)(97736003)(101416001)(4396001)(21056001)(1411001)(54206007)(76176999)(87936001)(68736005)(2656002)(33656002)(54356999)(50986999)(66066001)(2420400003)(54606007)(20776003)(102836002)(15975445007)(106116001)(31966008)(74316001)(105586002)(76576001)(99286002)(107046002)(86362001)(92566001)(99396003)(106356001)(120916001)(40100003)(110136001)(122556002)(77156002)(62966003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB071;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremiah,

Thank you very much for the solution. I will aplly it to my local patches immediately.

Do you think it is required to re-submit the patch set right now?

Thanks,
Dudley

> -----Original Message-----
> From: linux-input-owner@vger.kernel.org
> [mailto:linux-input-owner@vger.kernel.org] On Behalf Of Jeremiah Mahler
> Sent: 2014?12?10? 16:55
> To: Dudley Du
> Cc: linux-kernel@vger.kernel.org; linux-input@vger.kernel.org
> Subject: Re: [PATCH v13 09/12] input: cyapa: add gen5 trackpad device firmware
> update function support
>
> Dudley,
>
> On Tue, Dec 09, 2014 at 07:33:03PM -0800, Jeremiah Mahler wrote:
> > Dudley,
> >
> > On Tue, Dec 09, 2014 at 05:11:41PM +0800, Dudley Du wrote:
> > > Add firmware image update function supported for gen5 trackpad device,
> > > it can be used through sysfs update_fw interface.
> > > TEST=test on Chromebooks.
> > >
> > > Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
> > > ---
> > >  drivers/input/mouse/Kconfig      |   2 +-
> > >  drivers/input/mouse/cyapa_gen5.c | 290
> +++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 291 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> > > index d8b46b0..63e8b40 100644
> > > --- a/drivers/input/mouse/Kconfig
> > > +++ b/drivers/input/mouse/Kconfig
> > > @@ -205,7 +205,7 @@ config MOUSE_BCM5974
> > >
> > >  config MOUSE_CYAPA
> > >  tristate "Cypress APA I2C Trackpad support"
> > > -depends on I2C
> > > +depends on I2C && CRC_ITU_T
> If this line is instead changed to:
>
> +  depends on I2C
> +  select CRC_ITU_T
>
> It will upgrade correctly during make oldconfig without removing
> MOUSE_CYAPA.
>
> And it looks like several other Kconfig files do it this way already.
>
>   linux-next$ grep -r CRC_ITU_T $(find ./ -name Kconfig)
>
> > >  help
> > >    This driver adds support for Cypress All Points Addressable (APA)
> > >    I2C Trackpads, including the ones used in 2012 Samsung Chromebooks.
> > > diff --git a/drivers/input/mouse/cyapa_gen5.c
> b/drivers/input/mouse/cyapa_gen5.c
> >
> > My initial config had MOUSE_CYAPA=m and CRC_ITU_T=n.
> > I did a 'make oldconfig', no questions were asked, but it removed
> > MOUSE_CYAPA since CRC_ITU_T wasn't enabled.  Since the cyapa modules
> > were removed the touchpad no longer works.  Not a very good upgrade path :-(
> > To fix this I have to manually enable MOUSE_CYAPA and CRC_ITU_T to get
> > it working again.
> >
> > [...]
> >
> > --
> > - Jeremiah Mahler
>
> --
> - Jeremiah Mahler
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
