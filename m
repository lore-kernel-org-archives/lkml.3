Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3CAPSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:18:18 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.24]:32037
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab3CAPSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:18:15 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275ch8275dh8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Jiri Kosina <jkosina@suse.cz>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
Thread-Topic: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
Thread-Index: AQHN+dCsx+V+FBWESk2aq+oN9Eqam5hYQkaAgABz/iCAAAOHAIA4cQtA
Date: Fri, 1 Mar 2013 15:15:58 +0000
Message-ID: <524a403348d240a8b24db0177e7aaecd@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-6-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1301241108590.31600@pobox.suse.cz>
 <53da151ef8494d5084ef5aa089b9f102@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130124171740.GA5420@kroah.com>
In-Reply-To: <20130124171740.GA5420@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.130]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%HANSENPARTNERSHIP.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DAVEMLOFT.NET$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(189002)(377454001)(199002)(51704002)(24454001)(16676001)(47446002)(56776001)(50986001)(5343645001)(51856001)(5343635001)(74502001)(53806001)(54356001)(80022001)(77982001)(33646001)(49866001)(50466001)(65816001)(63696002)(59766001)(5343655001)(46102001)(56816002)(74662001)(46406002)(54316002)(47736001)(47776003)(47976001)(44976002)(23726001)(6806001)(66066001)(76482001)(4396001)(31966008)(20776003)(79102001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB017;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0772E5DAD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, January 24, 2013 12:18 PM
> To: KY Srinivasan
> Cc: Jiri Kosina; olaf@aepfle.de; jasowang@redhat.com; linux-
> kernel@vger.kernel.org; James.Bottomley@HansenPartnership.com;
> apw@canonical.com; devel@linuxdriverproject.org; davem@davemloft.net
> Subject: Re: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
> 
> On Thu, Jan 24, 2013 at 05:06:27PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Jiri Kosina [mailto:jkosina@suse.cz]
> > > Sent: Thursday, January 24, 2013 5:10 AM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > jasowang@redhat.com; davem@davemloft.net;
> > > James.Bottomley@HansenPartnership.com
> > > Subject: Re: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
> > >
> > > On Wed, 23 Jan 2013, K. Y. Srinivasan wrote:
> > >
> > > > Execute the shutdown code in a thread context. With recent changes made
> to
> > > the
> > > > shutdown code, shutdown code cannot be invoked from an interrupt
> context.
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > ---
> > > >  drivers/hv/hv_util.c |   12 +++++++++++-
> > > >  1 files changed, 11 insertions(+), 1 deletions(-)
> > > >
> > > > diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> > > > index 8b7868a..aceb67f 100644
> > > > --- a/drivers/hv/hv_util.c
> > > > +++ b/drivers/hv/hv_util.c
> > > > @@ -49,6 +49,16 @@ static struct hv_util_service util_kvp = {
> > > >  	.util_deinit = hv_kvp_deinit,
> > > >  };
> > > >
> > > > +static void perform_shutdown(struct work_struct *dummy)
> > > > +{
> > > > +		orderly_poweroff(true);
> > > > +}
> > >
> > > Is there any particular reason for this kind of crazy indentation?
> > I don't know how this extra tab crept through! Greg, if you want I can resend
> > this patch minus the extra tab. Let me know.
> 
> I'll edit it by hand, but someone owes me a beer for it...  :)

Greg,

You have already applied this. There has been some customer request for getting this
patch into 3.7 (3.7 is where the Hyper-V shutdown code ceased to work because of 
some other patches unrelated to Hyper-V that went in). What is the process for requesting
that this patch be applied all the way back to 3.7.

Regards,

K. Y
> 
> greg k-h
> 


