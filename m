Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbbANDVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 22:21:22 -0500
Received: from mail-bl2on0117.outbound.protection.outlook.com ([65.55.169.117]:64875
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752142AbbANDVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 22:21:21 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Topic: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Index: AQHQCjmjSzw/zQ+dsEi8PDH7zIFezJy+W/YWgADGp4CAABsV4A==
Date: Wed, 14 Jan 2015 03:21:18 +0000
Message-ID: <BY2PR0301MB07117C3BF4EDBAA1306BC15CA0410@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417093747-21073-1-git-send-email-decui@microsoft.com>
 <8761caeqjp.fsf@vitty.brq.redhat.com>
 <F792CF86EFE20D4AB8064279AFBA51C61EA7CFF9@SIXPRD3002MB028.064d.mgd.msft.net>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C61EA7CFF9@SIXPRD3002MB028.064d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:fd:59dd:bd2e:e8d9:683a]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0775;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0775;
x-forefront-prvs: 04569283F9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(199003)(13464003)(164054003)(51704005)(189002)(106356001)(74316001)(99286002)(106116001)(105586002)(101416001)(19580405001)(19580395003)(86612001)(551934003)(46102003)(40100003)(2561002)(122556002)(217423001)(86362001)(33656002)(87936001)(2656002)(54606007)(50986999)(76176999)(54356999)(54206007)(64706001)(76576001)(102836002)(2421001)(1511001)(92566002)(62966003)(77156002)(2900100001)(2950100001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0775;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2015 03:21:18.1112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0775
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui
> Sent: Tuesday, January 13, 2015 5:44 PM
> To: Vitaly Kuznetsov; KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; Haiyang Zhang
> Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> 
> > -----Original Message-----
> > From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> > Sent: Tuesday, January 13, 2015 21:52 PM
> > To: Dexuan Cui; KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > driverdev- devel@linuxdriverproject.org; olaf@aepfle.de;
> > apw@canonical.com; jasowang@redhat.com; Haiyang Zhang
> > Subject: Re: [PATCH v3] hv: hv_fcopy: drop the obsolete message on
> > transfer failure
> >
> > Dexuan Cui <decui@microsoft.com> writes:
> >
> > > In the case the user-space daemon crashes, hangs or is killed, we
> > > need to down the semaphore, otherwise, after the daemon starts next
> > > time, the obsolete data in fcopy_transaction.message or
> > > fcopy_transaction.fcopy_msg will be used immediately.
> >
> > It seems this patch got lost and I don't see it in recent 'resend'
> > series. K.Y., Dexuan, can you please take a look?
> Hi Vitaly, Jason,
> The patch can't fix all the corner cases (it would need non-trivial efforts for
> that) as we discussed, but I think it would be better for us to have it as it can
> indeed fix an obvious issue and doesn't introduce new issues.
> 
> I think I can document the known discussed corner cases in the patch as
> TODOs and resend the patch.
> 
> Please let me know if you have different opinions. :-)

Resend the patch.

K. Y
> 
> Thanks,
> -- Dexuan
> 
> >
> > >
> > > Cc: Jason Wang <jasowang@redhat.com>
> > > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > Cc: K. Y. Srinivasan <kys@microsoft.com>
> > > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > > ---
> > >
> > > v2: I removed the "FCP" prefix as Greg asked.
> > >
> > >     I also updated the output message a little:
> > >     "FCP: failed to acquire the semaphore" -->
> > >     "can not acquire the semaphore: it is benign"
> > >
> > > v3: I added the code in fcopy_release() as Jason Wang suggested.
> > >     I removed the pr_debug (it isn't so meaningful)and added a
> > > comment
> > instead.
> > >
> > >  drivers/hv/hv_fcopy.c | 19 +++++++++++++++++++
> > >  1 file changed, 19 insertions(+)
> > >
> > > diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c index
> > > 23b2ce2..faa6ba6 100644
> > > --- a/drivers/hv/hv_fcopy.c
> > > +++ b/drivers/hv/hv_fcopy.c
> > > @@ -86,6 +86,18 @@ static void fcopy_work_func(struct work_struct
> > *dummy)
> > >  	 * process the pending transaction.
> > >  	 */
> > >  	fcopy_respond_to_host(HV_E_FAIL);
> > > +
> > > +	/* In the case the user-space daemon crashes, hangs or is killed, we
> > > +	 * need to down the semaphore, otherwise, after the daemon starts
> > next
> > > +	 * time, the obsolete data in fcopy_transaction.message or
> > > +	 * fcopy_transaction.fcopy_msg will be used immediately.
> > > +	 *
> > > +	 * NOTE: fcopy_read() happens to get the semaphore (very rare)?
> We're
> > > +	 * still OK, because we've reported the failure to the host.
> > > +	 */
> > > +	if (down_trylock(&fcopy_transaction.read_sema))
> > > +		;
> > > +
> > >  }
> > >
> > >  static int fcopy_handle_handshake(u32 version) @@ -351,6 +363,13 @@
> > > static int fcopy_release(struct inode *inode, struct
> > file *f)
> > >  	 */
> > >  	in_hand_shake = true;
> > >  	opened = false;
> > > +
> > > +	if (cancel_delayed_work_sync(&fcopy_work)) {
> > > +		/* We haven't up()-ed the semaphore(very rare)? */
> > > +		if (down_trylock(&fcopy_transaction.read_sema))
> > > +			;
> > > +		fcopy_respond_to_host(HV_E_FAIL);
> > > +	}
> > >  	return 0;
> > >  }
> >
> > --
> >   Vitaly

