Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbaK0Lo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:44:56 -0500
Received: from mail-by2on0131.outbound.protection.outlook.com ([207.46.100.131]:25784
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755008AbaK0Loy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:44:54 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Jason Wang <jasowang@redhat.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        KY Srinivasan <kys@microsoft.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v2] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Topic: [PATCH v2] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Index: AQHQCiCqFBUCGSyvReGOHhAi+beE2px0MH3A
Date: Thu, 27 Nov 2014 11:44:17 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E646F7@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1417073491-19388-1-git-send-email-decui@microsoft.com>
	<1245181972.17067189.1417072471636.JavaMail.zimbra@redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E641D8@HKNPRD3002MB017.064d.mgd.msft.net>
 <1417078861.18179.2@smtp.corp.redhat.com>
In-Reply-To: <1417078861.18179.2@smtp.corp.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.133]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(189002)(13464003)(377454003)(199003)(164054003)(52604005)(51704005)(24454002)(84676001)(55846006)(2656002)(87936001)(86146001)(6806004)(19580405001)(44976005)(69596002)(19580395003)(68736004)(86362001)(4396001)(66066001)(92726001)(92566001)(86612001)(47776003)(20776003)(64706001)(16796002)(97736003)(31966008)(217423001)(120916001)(99396003)(23676002)(33656002)(551934003)(106116001)(26826002)(81156004)(106466001)(93886004)(46102003)(95666004)(110136001)(50466002)(21056001)(76176999)(54356999)(50986999)(107046002)(62966003)(77096003)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB285;H:mail.microsoft.com;FPR:;SPF:Pass;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB285;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB285;
X-Forefront-PRVS: 040866B734
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB285;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sARBj1cC024030

> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Thursday, November 27, 2014 17:01 PM
> To: Dexuan Cui
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com; KY
> Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> Subject: RE: [PATCH v2] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> On Thu, Nov 27, 2014 at 4:50 PM, Dexuan Cui <decui@microsoft.com> wrote:
> >>  -----Original Message-----
> >>  From: Jason Wang [mailto:jasowang@redhat.com]
> >>  Sent: Thursday, November 27, 2014 15:15 PM
> >>  To: Dexuan Cui
> >>  Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> >> driverdev-
> >>  devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com; KY
> >>  Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> >>  Subject: Re: [PATCH v2] hv: hv_fcopy: drop the obsolete message on
> >> transfer
> >>  failure
> >>  ----- Original Message -----
> >>  > In the case the user-space daemon crashes, hangs or is killed, we
> >>  > need to down the semaphore, otherwise, after the daemon starts
> >> next
> >>  > time, the obsolete data in fcopy_transaction.message or
> >>  > fcopy_transaction.fcopy_msg will be used immediately.
> >>  >
> >>  > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >>  > Cc: K. Y. Srinivasan <kys@microsoft.com>
> >>  > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> >>  > ---
> >>  >
> >>  > v2: I removed the "FCP" prefix as Greg asked.
> >>  >
> >>  >     I also updated the output message a little:
> >>  >     "FCP: failed to acquire the semaphore" -->
> >>  >     "can not acquire the semaphore: it is benign"
> >>  >
> >>  >  drivers/hv/hv_fcopy.c | 9 +++++++++
> >>  >  1 file changed, 9 insertions(+)
> >>  >
> >>  > diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
> >>  > index 23b2ce2..c518ad9 100644
> >>  > --- a/drivers/hv/hv_fcopy.c
> >>  > +++ b/drivers/hv/hv_fcopy.c
> >>  > @@ -86,6 +86,15 @@ static void fcopy_work_func(struct work_struct
> >>  *dummy)
> >>  >  	 * process the pending transaction.
> >>  >  	 */
> >>  >  	fcopy_respond_to_host(HV_E_FAIL);
> >>  > +
> >>  > +	/* In the case the user-space daemon crashes, hangs or is
> >> killed, we
> >>  > +	 * need to down the semaphore, otherwise, after the daemon
> >> starts
> >>  next
> >>  > +	 * time, the obsolete data in fcopy_transaction.message or
> >>  > +	 * fcopy_transaction.fcopy_msg will be used immediately.
> >>  > +	 */
> >>
> >>  Looks still racy, what happens if the daemon start before
> >> down_trylock()
> >>  but after fcopy_respont_to_host() here?
> > Jason,
> > Thanks for pointing this out!
> > IMO we can resolve this by adding down_trylock() in fcopy_release().
> > What's your opinion?
> 
> 
> Looks better and need to cancel the timeout also here?
OK, let me post a v3.

> >
> >
> >>
> >>  > +	if (down_trylock(&fcopy_transaction.read_sema))
> >>  > +		pr_debug("can not acquire the semaphore: it is benign\n");
> >>
> >>  typo
> >>  > +
> >>  >  }
> > Sorry -- what typo do you mean?
> 
> s/benign/begin/ ?
I meant the issue(can't get the semaphore) is benign.

I think we can just remove the message, as KY suggested.
Instead, I'll add a comment for it.

Thanks,
-- Dexuan

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
