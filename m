Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbaK1Ig3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:36:29 -0500
Received: from mail-bn1bn0104.outbound.protection.outlook.com ([157.56.110.104]:60144
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750901AbaK1Ig1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:36:27 -0500
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
Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Topic: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Index: AQHQCtc/Tepp2fiJgUel+58IpcrHxpx1sh6g
Date: Fri, 28 Nov 2014 08:36:07 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E66566@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1417093747-21073-1-git-send-email-decui@microsoft.com>
 <1417157243.3268.1@smtp.corp.redhat.com>
In-Reply-To: <1417157243.3268.1@smtp.corp.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.132]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(199003)(51704005)(377454003)(189002)(24454002)(13464003)(46102003)(81156004)(26826002)(551934003)(106116001)(33656002)(19580405001)(44976005)(6806004)(107046002)(86362001)(68736004)(69596002)(19580395003)(86612001)(106466001)(95666004)(84676001)(92726001)(20776003)(47776003)(64706001)(66066001)(50466002)(92566001)(120916001)(97736003)(31966008)(16796002)(217423001)(62966003)(23676002)(77156002)(77096003)(86146001)(55846006)(87936001)(2656002)(99396003)(76176999)(54356999)(110136001)(50986999)(21056001)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1211;H:mail.microsoft.com;FPR:;SPF:Pass;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1211;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1211;
X-Forefront-PRVS: 04097B7F7F
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1211;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAS8aZdr029758

> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Friday, November 28, 2014 14:47 PM
> To: Dexuan Cui
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com; KY
> Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> Subject: Re: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> On Thu, Nov 27, 2014 at 9:09 PM, Dexuan Cui <decui@microsoft.com> wrote:
> > In the case the user-space daemon crashes, hangs or is killed, we
> > need to down the semaphore, otherwise, after the daemon starts next
> > time, the obsolete data in fcopy_transaction.message or
> > fcopy_transaction.fcopy_msg will be used immediately.
> >
> > Cc: Jason Wang <jasowang@redhat.com>
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Cc: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > ---
> >
> > v2: I removed the "FCP" prefix as Greg asked.
> >
> >     I also updated the output message a little:
> >     "FCP: failed to acquire the semaphore" -->
> >     "can not acquire the semaphore: it is benign"
> >
> > v3: I added the code in fcopy_release() as Jason Wang suggested.
> >     I removed the pr_debug (it isn't so meaningful)and added a
> > comment instead.
> >
> >  drivers/hv/hv_fcopy.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
> > index 23b2ce2..faa6ba6 100644
> > --- a/drivers/hv/hv_fcopy.c
> > +++ b/drivers/hv/hv_fcopy.c
> > @@ -86,6 +86,18 @@ static void fcopy_work_func(struct work_struct
> > *dummy)
> >  	 * process the pending transaction.
> >  	 */
> >  	fcopy_respond_to_host(HV_E_FAIL);
> > +
> > +	/* In the case the user-space daemon crashes, hangs or is killed, we
> > +	 * need to down the semaphore, otherwise, after the daemon starts
> > next
> > +	 * time, the obsolete data in fcopy_transaction.message or
> > +	 * fcopy_transaction.fcopy_msg will be used immediately.
> > +	 *
> > +	 * NOTE: fcopy_read() happens to get the semaphore (very rare)?
> > We're
> > +	 * still OK, because we've reported the failure to the host.
> > +	 */
> > +	if (down_trylock(&fcopy_transaction.read_sema))
> > +		;
> 
> Sorry, I'm not quite understand how if () ; can help here.
> 
> Btw, a question not relate to this patch.
> 
> What happens if a daemon is resume from SIGSTOP and expires the check
> here?
Hi Jason,
My idea is: here we need down_trylock(), but in case we can't get the
semaphore, it's OK anyway:

Scenario 1):
1.1: when the daemon is blocked on the pread(), the daemon receives SIGSTOP;
1.2: the host user runs the PowerShell Copy-VMFile command;
1.3.1: the driver reports the failure to the host user in 5s and
1.3.2: the driver down()-es the semaphore;
1.4: the daemon receives SIGCONT and it will be still blocked on the pread().
Without the down_trylock(), in 1.4, the daemon can receive an obsolete message.
NOTE: in this scenario, the daemon is not killed.

Scenario 2):
In senario 1), if the daemon receives SIGCONT between 1.3.1 and 1.3.2 and
do down() in fcopy_read(), it will receive the message but: the driver has
reported the failure to the host user and the driver's 1.3.2 can't get the
semaphore -- IMO this is acceptably OK, though in the VM, an incomplete
file will be left there.
BTW, I think in the daemon's hv_start_fcopy() we should add a
close(target_fd) before open()-ing a new one.

> >
> > +
> >  }
> >
> >  static int fcopy_handle_handshake(u32 version)
> > @@ -351,6 +363,13 @@ static int fcopy_release(struct inode *inode,
> > struct file *f)
> >  	 */
> >  	in_hand_shake = true;
> >  	opened = false;
> > +
> > +	if (cancel_delayed_work_sync(&fcopy_work)) {
> > +		/* We haven't up()-ed the semaphore(very rare)? */
> > +		if (down_trylock(&fcopy_transaction.read_sema))
> > +			;
> 
> And this.

Scenario 3):
When the daemon exits(e.g., SIGKILL received), if there is a fcopy_work
pending (scheduled but not start to run yet), we should cancel the
work (as you suggested) and down() the semaphore, otherwise, the
obsolete message will be received by the next instance of the daemon.

Scenario 4):  in the driver's hv_fcopy_onchannelcallback():
        schedule_delayed_work(&fcopy_work, 5*HZ);
        ----> if fcopy_release() is running on another vcpu, just before the next line?
        fcopy_send_data();

In this case, fcopy_release() can cancel fcopy_work, but
can't get the semaphore since it hasn't been up()-ed.
Hmm, in this case,   fcopy_send_data() will do up()  later, and we'll
buffer an obsolete message in the driver, and the message will be
fetched by the next instance of the daemon... 

Looks we need a spinlock here?

Please share your idea.

> >
> > +		fcopy_respond_to_host(HV_E_FAIL);
> > +	}
> >  	return 0;
> >  }
> >
> > --
> > 1.9.1
> >

-- Dexuan

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
