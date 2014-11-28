Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaK1Lzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:55:47 -0500
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:59760
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751057AbaK1Lzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:55:45 -0500
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
Thread-Index: AQHQCvPfTepp2fiJgUel+58IpcrHxpx16bLA
Date: Fri, 28 Nov 2014 11:54:59 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E66AAA@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1417093747-21073-1-git-send-email-decui@microsoft.com>
	<1417157243.3268.1@smtp.corp.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E66566@HKNPRD3002MB017.064d.mgd.msft.net>
 <1417169573.5822.12@smtp.corp.redhat.com>
In-Reply-To: <1417169573.5822.12@smtp.corp.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.132]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(189002)(24454002)(13464003)(199003)(51704005)(377454003)(86612001)(107046002)(97736003)(106116001)(120916001)(92566001)(86362001)(92726001)(106466001)(81156004)(93886004)(26826002)(46102003)(77156002)(99396003)(62966003)(77096003)(95666004)(76176999)(33656002)(84676001)(31966008)(2656002)(87936001)(64706001)(20776003)(47776003)(66066001)(16796002)(217423001)(551934003)(55846006)(50466002)(4396001)(21056001)(110136001)(68736004)(86146001)(44976005)(6806004)(23676002)(50986999)(54356999)(69596002)(19580395003)(19580405001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1204;H:mail.microsoft.com;FPR:;SPF:Pass;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1204;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1204;
X-Forefront-PRVS: 04097B7F7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1204;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sASBu9i4030801

> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Friday, November 28, 2014 18:13 PM
> To: Dexuan Cui
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com; KY
> Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> On Fri, Nov 28, 2014 at 4:36 PM, Dexuan Cui <decui@microsoft.com> wrote:
> >>  -----Original Message-----
> >>  From: Jason Wang [mailto:jasowang@redhat.com]
> >>  Sent: Friday, November 28, 2014 14:47 PM
> >>  To: Dexuan Cui
> >>  Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> >> driverdev-
> >>  devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com; KY
> >>  Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> >>  Subject: Re: [PATCH v3] hv: hv_fcopy: drop the obsolete message on
> >> transfer
> >>  failure
> >>  On Thu, Nov 27, 2014 at 9:09 PM, Dexuan Cui <decui@microsoft.com>
> >> wrote:
> >>  > In the case the user-space daemon crashes, hangs or is killed, we
> >>  > need to down the semaphore, otherwise, after the daemon starts
> >> next
> >>  > time, the obsolete data in fcopy_transaction.message or
> >>  > fcopy_transaction.fcopy_msg will be used immediately.
> >>  >
> >>  > Cc: Jason Wang <jasowang@redhat.com>
> >>  > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
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
> >>  > v3: I added the code in fcopy_release() as Jason Wang suggested.
> >>  >     I removed the pr_debug (it isn't so meaningful)and added a
> >>  > comment instead.
> >>  >
> >>  >  drivers/hv/hv_fcopy.c | 19 +++++++++++++++++++
> >>  >  1 file changed, 19 insertions(+)
> >>  >
> >>  > diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
> >>  > index 23b2ce2..faa6ba6 100644
> >>  > --- a/drivers/hv/hv_fcopy.c
> >>  > +++ b/drivers/hv/hv_fcopy.c
> >>  > @@ -86,6 +86,18 @@ static void fcopy_work_func(struct work_struct
> >>  > *dummy)
> >>  >  	 * process the pending transaction.
> >>  >  	 */
> >>  >  	fcopy_respond_to_host(HV_E_FAIL);
> >>  > +
> >>  > +	/* In the case the user-space daemon crashes, hangs or is
> >> killed, we
> >>  > +	 * need to down the semaphore, otherwise, after the daemon
> >> starts
> >>  > next
> >>  > +	 * time, the obsolete data in fcopy_transaction.message or
> >>  > +	 * fcopy_transaction.fcopy_msg will be used immediately.
> >>  > +	 *
> >>  > +	 * NOTE: fcopy_read() happens to get the semaphore (very rare)?
> >>  > We're
> >>  > +	 * still OK, because we've reported the failure to the host.
> >>  > +	 */
> >>  > +	if (down_trylock(&fcopy_transaction.read_sema))
> >>  > +		;
> >>
> >>  Sorry, I'm not quite understand how if () ; can help here.
> >>
> >>  Btw, a question not relate to this patch.
> >>
> >>  What happens if a daemon is resume from SIGSTOP and expires the
> >> check
> >>  here?
> > Hi Jason,
> > My idea is: here we need down_trylock(), but in case we can't get the
> > semaphore, it's OK anyway:
> >
> > Scenario 1):
> > 1.1: when the daemon is blocked on the pread(), the daemon receives
> > SIGSTOP;
> > 1.2: the host user runs the PowerShell Copy-VMFile command;
> > 1.3.1: the driver reports the failure to the host user in 5s and
> > 1.3.2: the driver down()-es the semaphore;
> > 1.4: the daemon receives SIGCONT and it will be still blocked on the
> > pread().
> > Without the down_trylock(), in 1.4, the daemon can receive an
> > obsolete message.
> > NOTE: in this scenario, the daemon is not killed.
> >
> > Scenario 2):
> > In senario 1), if the daemon receives SIGCONT between 1.3.1 and 1.3.2
> > and
> > do down() in fcopy_read(), it will receive the message but: the
> > driver has
> > reported the failure to the host user and the driver's 1.3.2 can't
> > get the
> > semaphore -- IMO this is acceptably OK, though in the VM, an
> > incomplete
> > file will be left there.
> > BTW, I think in the daemon's hv_start_fcopy() we should add a
> > close(target_fd) before open()-ing a new one.
> 
> Right, but how about the case when resuming from SIGSTOP but no timeout?
Sorry, I don't understand this:
if no timeout, fcopy_read() will get the semaphore and fcopy_write()
will try to cancel fcopy_work.

> Looks like in this case userspace() may wait in down_interruptible()
> until timeout. We probably need something like this:
> 
>         if (down_interruptible(&fcopy_transaction.read_sema)) {
>                 up(&fcopy_transaction.read_sema);
>                 return -EINTR;
>         }
until "timeout"?
if the daemon can't get the semaphore, it can only be wake by a signal(the
daemon doesn't install handler, so by default most signals will kill the daemon).
In case a signal waking up the daemon doesn't kill the daemon, why should
we do up()?

> 
> This should synchronize with the timeout work for sure.
> But how about only schedule it after this?
> It does not may sense to start the timer during interrupt
> since the file may not even opened and it may take time
> to handle signals?
> 
> >
> >>  >
> >>  > +
> >>  >  }
> >>  >
> >>  >  static int fcopy_handle_handshake(u32 version)
> >>  > @@ -351,6 +363,13 @@ static int fcopy_release(struct inode *inode,
> >>  > struct file *f)
> >>  >  	 */
> >>  >  	in_hand_shake = true;
> >>  >  	opened = false;
> >>  > +
> >>  > +	if (cancel_delayed_work_sync(&fcopy_work)) {
> >>  > +		/* We haven't up()-ed the semaphore(very rare)? */
> >>  > +		if (down_trylock(&fcopy_transaction.read_sema))
> >>  > +			;
> >>
> >>  And this.
> >
> > Scenario 3):
> > When the daemon exits(e.g., SIGKILL received), if there is a
> > fcopy_work
> > pending (scheduled but not start to run yet), we should cancel the
> > work (as you suggested) and down() the semaphore, otherwise, the
> > obsolete message will be received by the next instance of the daemon.
> 
> Yes
> >
> >
> > Scenario 4):  in the driver's hv_fcopy_onchannelcallback():
> >         schedule_delayed_work(&fcopy_work, 5*HZ);
> >         ----> if fcopy_release() is running on another vcpu, just
> > before the next line?
> >         fcopy_send_data();
> >
> > In this case, fcopy_release() can cancel fcopy_work, but
> > can't get the semaphore since it hasn't been up()-ed.
> > Hmm, in this case,   fcopy_send_data() will do up()  later, and we'll
> > buffer an obsolete message in the driver, and the message will be
> > fetched by the next instance of the daemon...
> >
> > Looks we need a spinlock here?
> 
> Unless fcopy_release() can wait for all data for current transation
> to be received. Spinlock won't help.
> 
> But an idea is let the daemon the handle such cases. E.g make sure the
> processing begins with START_COPY and end with COMPLETE/CANCEL_COPY.
> Drop all requests that does not start with START_COPY.
> 
> Thought?
Good idea.
I also think we should reinforce the concept of state machine in the
daemon code.

The daemon/driver communication has so many corner cases...

> >
> >>  >
> >>  > +		fcopy_respond_to_host(HV_E_FAIL);
> >>  > +	}
> >>  >  	return 0;
> >>  >  }
> >>  >
> >>  > --
> >>  > 1.9.1
> >>  >

 -- Dexuan

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
