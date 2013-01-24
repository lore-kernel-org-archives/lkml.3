Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3AXRJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:09:35 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.32]:35021
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3AXRJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:09:33 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
Thread-Topic: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
Thread-Index: AQHN+dCsx+V+FBWESk2aq+oN9Eqam5hYQkaAgABz/iA=
Date: Thu, 24 Jan 2013 17:06:27 +0000
Message-ID: <53da151ef8494d5084ef5aa089b9f102@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-6-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1301241108590.31600@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1301241108590.31600@pobox.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.166]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%HANSENPARTNERSHIP.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DAVEMLOFT.NET$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454001)(51704002)(13464002)(377454001)(50466001)(54356001)(53806001)(74662001)(47736001)(6806001)(50986001)(76482001)(54316002)(47976001)(16676001)(74502001)(49866001)(63696002)(44976002)(33646001)(31966008)(4396001)(47446002)(51856001)(56816002)(5343635001)(79102001)(46102001)(56776001)(59766001)(77982001)(23726001)(46406002)(47776003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB025;H:TK5EX14HUBC106.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 073631BD3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jiri Kosina [mailto:jkosina@suse.cz]
> Sent: Thursday, January 24, 2013 5:10 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; davem@davemloft.net;
> James.Bottomley@HansenPartnership.com
> Subject: Re: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
> 
> On Wed, 23 Jan 2013, K. Y. Srinivasan wrote:
> 
> > Execute the shutdown code in a thread context. With recent changes made to
> the
> > shutdown code, shutdown code cannot be invoked from an interrupt context.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/hv/hv_util.c |   12 +++++++++++-
> >  1 files changed, 11 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> > index 8b7868a..aceb67f 100644
> > --- a/drivers/hv/hv_util.c
> > +++ b/drivers/hv/hv_util.c
> > @@ -49,6 +49,16 @@ static struct hv_util_service util_kvp = {
> >  	.util_deinit = hv_kvp_deinit,
> >  };
> >
> > +static void perform_shutdown(struct work_struct *dummy)
> > +{
> > +		orderly_poweroff(true);
> > +}
> 
> Is there any particular reason for this kind of crazy indentation?
I don't know how this extra tab crept through! Greg, if you want I can resend
this patch minus the extra tab. Let me know.

Regards,

K. Y
> 
> --
> Jiri Kosina
> SUSE Labs
> 


