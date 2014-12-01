Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaLAJsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:48:08 -0500
Received: from mail-by2on0101.outbound.protection.outlook.com ([207.46.100.101]:26347
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752039AbaLAJsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:48:06 -0500
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
Thread-Index: AQHQDT/6Tepp2fiJgUel+58IpcrHxpx6efaA
Date: Mon, 1 Dec 2014 09:47:14 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E691B8@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1417093747-21073-1-git-send-email-decui@microsoft.com>
	<1417157243.3268.1@smtp.corp.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E66566@HKNPRD3002MB017.064d.mgd.msft.net>
	<1417169573.5822.12@smtp.corp.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E66AAA@HKNPRD3002MB017.064d.mgd.msft.net>
 <1417422163.877.1@smtp.corp.redhat.com>
In-Reply-To: <1417422163.877.1@smtp.corp.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.133]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(51704005)(189002)(199003)(377454003)(24454002)(164054003)(13464003)(95666004)(86146001)(86612001)(23676002)(120916001)(15975445006)(99396003)(19580395003)(44976005)(69596002)(19580405001)(6806004)(68736004)(97736003)(84676001)(77096004)(106116001)(106466001)(81156004)(33656002)(87936001)(110136001)(26826002)(107046002)(551934003)(86362001)(2656002)(46102003)(92566001)(92726001)(50466002)(4396001)(31966008)(16796002)(217423001)(76176999)(54356999)(50986999)(93886004)(21056001)(77156002)(55846006)(62966003)(47776003)(20776003)(64706001)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1207;H:mail.microsoft.com;FPR:;SPF:Pass;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1207;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1207;
X-Forefront-PRVS: 0412A98A59
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1207;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1223;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB19mF57007892

> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Monday, December 1, 2014 16:23 PM
> To: Dexuan Cui
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com; KY
> Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> On Fri, Nov 28, 2014 at 7:54 PM, Dexuan Cui <decui@microsoft.com> wrote:
> >>  -----Original Message-----
> >>  From: Jason Wang [mailto:jasowang@redhat.com]
> >>  Sent: Friday, November 28, 2014 18:13 PM
> >>  To: Dexuan Cui
> >>  Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> >> driverdev-
> >>  devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com; KY
> >>  Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> >>  Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on
> >> transfer
> >>  failure
> >>  On Fri, Nov 28, 2014 at 4:36 PM, Dexuan Cui <decui@microsoft.com>
> >> wrote:
> >>  >>  -----Original Message-----
> >>  >>  From: Jason Wang [mailto:jasowang@redhat.com]
> >>  >>  Sent: Friday, November 28, 2014 14:47 PM
> >>  >>  To: Dexuan Cui
> >>  >>  Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> >>  >> driverdev-
> >>  >>  devel@linuxdriverproject.org; olaf@aepfle.de;
> >> apw@canonical.com; KY
> >>  >>  Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> >>  >>  Subject: Re: [PATCH v3] hv: hv_fcopy: drop the obsolete message
> >> on
> >>  >> transfer
> >>  >>  failure
> >>  >>  On Thu, Nov 27, 2014 at 9:09 PM, Dexuan Cui
> >> <decui@microsoft.com>
> >>  >> wrote:
> >>  >>  > In the case the user-space daemon crashes, hangs or is
> >> killed, we
> >>  >>  > need to down the semaphore, otherwise, after the daemon starts
> >>  >> next
> >>  >>  > time, the obsolete data in fcopy_transaction.message or
> >>  >>  > fcopy_transaction.fcopy_msg will be used immediately.
> >>  >>  >
> >>  >>  > Cc: Jason Wang <jasowang@redhat.com>
> >>  >>  > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> >>  >>  > Cc: K. Y. Srinivasan <kys@microsoft.com>
> >>  >>  > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> >>  >>  > ---
> >>  >>  >
> >>  >>  > v2: I removed the "FCP" prefix as Greg asked.
> >>  >>  >
> >>  >>  >     I also updated the output message a little:
> >>  >>  >     "FCP: failed to acquire the semaphore" -->
> >>  >>  >     "can not acquire the semaphore: it is benign"
> >>  >>  >
> >>  >>  > v3: I added the code in fcopy_release() as Jason Wang
> >> suggested.
> >>  >>  >     I removed the pr_debug (it isn't so meaningful)and added a
> >>  >>  > comment instead.
> >>  >>  >
> >>  >>  >  drivers/hv/hv_fcopy.c | 19 +++++++++++++++++++
> >>  >>  >  1 file changed, 19 insertions(+)
> >>  >>  >
> >>  >>  > diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
> >>  >>  > index 23b2ce2..faa6ba6 100644
> >>  >>  > --- a/drivers/hv/hv_fcopy.c
> >>  >>  > +++ b/drivers/hv/hv_fcopy.c
> >>  >>  > @@ -86,6 +86,18 @@ static void fcopy_work_func(struct
> >> work_struct
> >>  >>  > *dummy)
> >>  >>  >  	 * process the pending transaction.
> >>  >>  >  	 */
> >>  >>  >  	fcopy_respond_to_host(HV_E_FAIL);
> >>  >>  > +
> >>  >>  > +	/* In the case the user-space daemon crashes, hangs or is
> >>  >> killed, we
> >>  >>  > +	 * need to down the semaphore, otherwise, after the daemon
> >>  >> starts
> >>  >>  > next
> >>  >>  > +	 * time, the obsolete data in fcopy_transaction.message or
> >>  >>  > +	 * fcopy_transaction.fcopy_msg will be used immediately.
> >>  >>  > +	 *
> >>  >>  > +	 * NOTE: fcopy_read() happens to get the semaphore (very
> >> rare)?
> >>  >>  > We're
> >>  >>  > +	 * still OK, because we've reported the failure to the host.
> >>  >>  > +	 */
> >>  >>  > +	if (down_trylock(&fcopy_transaction.read_sema))
> >>  >>  > +		;
> >>  >>
> >>  >>  Sorry, I'm not quite understand how if () ; can help here.
> >>  >>
> >>  >>  Btw, a question not relate to this patch.
> >>  >>
> >>  >>  What happens if a daemon is resume from SIGSTOP and expires the
> >>  >> check
> >>  >>  here?
> >>  > Hi Jason,
> >>  > My idea is: here we need down_trylock(), but in case we can't get
> >> the
> >>  > semaphore, it's OK anyway:
> >>  >
> >>  > Scenario 1):
> >>  > 1.1: when the daemon is blocked on the pread(), the daemon
> >> receives
> >>  > SIGSTOP;
> >>  > 1.2: the host user runs the PowerShell Copy-VMFile command;
> >>  > 1.3.1: the driver reports the failure to the host user in 5s and
> >>  > 1.3.2: the driver down()-es the semaphore;
> >>  > 1.4: the daemon receives SIGCONT and it will be still blocked on
> >> the
> >>  > pread().
> >>  > Without the down_trylock(), in 1.4, the daemon can receive an
> >>  > obsolete message.
> >>  > NOTE: in this scenario, the daemon is not killed.
> >>  >
> >>  > Scenario 2):
> >>  > In senario 1), if the daemon receives SIGCONT between 1.3.1 and
> >> 1.3.2
> >>  > and
> >>  > do down() in fcopy_read(), it will receive the message but: the
> >>  > driver has
> >>  > reported the failure to the host user and the driver's 1.3.2 can't
> >>  > get the
> >>  > semaphore -- IMO this is acceptably OK, though in the VM, an
> >>  > incomplete
> >>  > file will be left there.
> >>  > BTW, I think in the daemon's hv_start_fcopy() we should add a
> >>  > close(target_fd) before open()-ing a new one.
> >>
> >>  Right, but how about the case when resuming from SIGSTOP but no
> >> timeout?
> > Sorry, I don't understand this:
> > if no timeout, fcopy_read() will get the semaphore and fcopy_write()
> > will try to cancel fcopy_work.
> 
> Yes.
> >
> >
> >>  Looks like in this case userspace() may wait in down_interruptible()
> >>  until timeout. We probably need something like this:
> >>
> >>          if (down_interruptible(&fcopy_transaction.read_sema)) {
> >>                  up(&fcopy_transaction.read_sema);
> >>                  return -EINTR;
> >>          }
> > until "timeout"?
> > if the daemon can't get the semaphore, it can only be wake by a
> > signal(the
> > daemon doesn't install handler, so by default most signals will kill
> > the daemon).
> > In case a signal waking up the daemon doesn't kill the daemon, why
> > should
> > we do up()?
> 
> True, no need since we do down_trylock() in release().
> 
> Btw, there's no EINTR handling in handling pread() return value,
> may add such one which should be useful for something like debugging.
> 
> >
> >
> >>
> >>  This should synchronize with the timeout work for sure.
> >>  But how about only schedule it after this?
> >>  It does not may sense to start the timer during interrupt
> >>  since the file may not even opened and it may take time
> >>  to handle signals?
> >>
> >>  >
> >>  >>  >
> >>  >>  > +
> >>  >>  >  }
> >>  >>  >
> >>  >>  >  static int fcopy_handle_handshake(u32 version)
> >>  >>  > @@ -351,6 +363,13 @@ static int fcopy_release(struct inode
> >> *inode,
> >>  >>  > struct file *f)
> >>  >>  >  	 */
> >>  >>  >  	in_hand_shake = true;
> >>  >>  >  	opened = false;
> >>  >>  > +
> >>  >>  > +	if (cancel_delayed_work_sync(&fcopy_work)) {
> >>  >>  > +		/* We haven't up()-ed the semaphore(very rare)? */
> >>  >>  > +		if (down_trylock(&fcopy_transaction.read_sema))
> >>  >>  > +			;
> >>  >>
> >>  >>  And this.
> >>  >
> >>  > Scenario 3):
> >>  > When the daemon exits(e.g., SIGKILL received), if there is a
> >>  > fcopy_work
> >>  > pending (scheduled but not start to run yet), we should cancel the
> >>  > work (as you suggested) and down() the semaphore, otherwise, the
> >>  > obsolete message will be received by the next instance of the
> >> daemon.
> >>
> >>  Yes
> >>  >
> >>  >
> >>  > Scenario 4):  in the driver's hv_fcopy_onchannelcallback():
> >>  >         schedule_delayed_work(&fcopy_work, 5*HZ);
> >>  >         ----> if fcopy_release() is running on another vcpu, just
> >>  > before the next line?
> >>  >         fcopy_send_data();
> >>  >
> >>  > In this case, fcopy_release() can cancel fcopy_work, but
> >>  > can't get the semaphore since it hasn't been up()-ed.
> >>  > Hmm, in this case,   fcopy_send_data() will do up()  later, and
> >> we'll
> >>  > buffer an obsolete message in the driver, and the message will be
> >>  > fetched by the next instance of the daemon...
> >>  >
> >>  > Looks we need a spinlock here?
> >>
> >>  Unless fcopy_release() can wait for all data for current transation
> >>  to be received. Spinlock won't help.
> >>
> >>  But an idea is let the daemon the handle such cases. E.g make sure
> >> the
> >>  processing begins with START_COPY and end with
> COMPLETE/CANCEL_COPY.
> >>  Drop all requests that does not start with START_COPY.
> >>
> >>  Thought?
> > Good idea.
> > I also think we should reinforce the concept of state machine in the
> > daemon code.
> 
> Yes, it needs.
I agree.
Obviously we can do something to make the daemon/driver work better
in the corner cases.

> >
> > The daemon/driver communication has so many corner cases...
> 
> Looks so, let's first address the issue mentioned in this patch.
OK.

> I don't have any more comments other than changing
> 
>  if(down_trylock(&fcopy_transaction.read_sema))
>      ;
> 
> to
> 
> down_trylock(&fcopy_transaction.read_sema);
Hi Jason,
This is to address Vitaly's comment in the bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=1162100#c5

down_trylock(&fcopy_transaction.read_sema) will

"
produces the following compile warning:
drivers/hv/hv_fcopy.c: In function ‚Äòfcopy_work_func‚Äô:
drivers/hv/hv_fcopy.c:95:2: warning: ignoring return value of ‚Äòdown_trylock‚Äô, declared with attribute warn_unused_result [-Wunused-result]
  (void)down_trylock(&fcopy_transaction.read_sema);
"

Actually I personally don't care about the warning, because we only
see it when we run some kind of code checker program.  :-)

I can change my v3  to the "normal" style you prefer, if
there is no strong objection from Vitaly?

Thanks,
-- Dexuan

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
