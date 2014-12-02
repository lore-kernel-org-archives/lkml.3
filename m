Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbaLBFel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:34:41 -0500
Received: from mail-bn1on0118.outbound.protection.outlook.com ([157.56.110.118]:42362
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752714AbaLBFek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:34:40 -0500
From: Dexuan Cui <decui@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Jason Wang <jasowang@redhat.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Topic: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Index: AQHQDVAjTepp2fiJgUel+58IpcrHxpx6jwLQgABUqoCAAOIqMA==
Date: Tue, 2 Dec 2014 05:33:25 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E6B93B@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1417093747-21073-1-git-send-email-decui@microsoft.com>
	<1417157243.3268.1@smtp.corp.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E66566@HKNPRD3002MB017.064d.mgd.msft.net>
	<1417169573.5822.12@smtp.corp.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E66AAA@HKNPRD3002MB017.064d.mgd.msft.net>
	<1417422163.877.1@smtp.corp.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E691B8@HKNPRD3002MB017.064d.mgd.msft.net>
 <1417429104.4907.0@smtp.corp.redhat.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E69318@HKNPRD3002MB017.064d.mgd.msft.net>
 <BY2PR0301MB0711B72633E429F8F33F8871A07D0@BY2PR0301MB0711.namprd03.prod.outlook.com>
In-Reply-To: <BY2PR0301MB0711B72633E429F8F33F8871A07D0@BY2PR0301MB0711.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.133]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(13464003)(24454002)(199003)(51704005)(189002)(377454003)(479174003)(21056001)(62966003)(55846006)(77156002)(93886004)(50466002)(4396001)(46102003)(92726001)(92566001)(76176999)(54356999)(50986999)(217423001)(31966008)(16796002)(1511001)(64706001)(66066001)(20776003)(44976005)(19580395003)(47776003)(6806004)(19580405001)(69596002)(120916001)(99396003)(15975445006)(97736003)(84676001)(86146001)(2561002)(95666004)(23676002)(86612001)(86362001)(575784001)(33656002)(2421001)(2656002)(81156004)(106466001)(77096004)(106116001)(87936001)(107046002)(551934003)(26826002)(68736005);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1210;H:mail.microsoft.com;FPR:;SPF:Pass;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1210;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1210;
X-Forefront-PRVS: 0413C9F1ED
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1210;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB25YpKZ014355

> -----Original Message-----
> From: KY Srinivasan
> Sent: Monday, December 1, 2014 23:55 PM
> To: Dexuan Cui; Jason Wang
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> vkuznets@redhat.com; Haiyang Zhang
> Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> 
> 
> 
> > -----Original Message-----
> > From: Dexuan Cui
> > Sent: Monday, December 1, 2014 3:01 AM
> > To: Jason Wang
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com; KY
> > Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> > Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
> > failure
> >
> > > -----Original Message-----
> > > From: Jason Wang [mailto:jasowang@redhat.com]
> > > Sent: Monday, December 1, 2014 18:18 PM
> > > To: Dexuan Cui
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > driverdev- devel@linuxdriverproject.org; olaf@aepfle.de;
> > > apw@canonical.com; KY Srinivasan; vkuznets@redhat.com; Haiyang
> Zhang
> > > Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on
> > > transfer failure
> > >
> > >
> > >
> > > On Mon, Dec 1, 2014 at 5:47 PM, Dexuan Cui <decui@microsoft.com>
> > wrote:
> > > >>  -----Original Message-----
> > > >>  From: Jason Wang [mailto:jasowang@redhat.com]
> > > >>  Sent: Monday, December 1, 2014 16:23 PM
> > > >>  To: Dexuan Cui
> > > >>  Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > >> driverdev-
> > > >>  devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > >> KY  Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> > > >>  Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on
> > > >> transfer  failure  On Fri, Nov 28, 2014 at 7:54 PM, Dexuan Cui
> > > >> <decui@microsoft.com>
> > > >> wrote:
> > > >>  >>  -----Original Message-----
> > > >>  >>  From: Jason Wang [mailto:jasowang@redhat.com]  >>  Sent:
> > > >> Friday, November 28, 2014 18:13 PM  >>  To: Dexuan Cui  >>  Cc:
> > > >> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;  >>
> > > >> driverdev-  >>  devel@linuxdriverproject.org; olaf@aepfle.de;
> > > >> apw@canonical.com; KY  >>  Srinivasan; vkuznets@redhat.com;
> Haiyang
> > > >> Zhang  >>  Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete
> > > >> message on  >> transfer  >>  failure  >>  On Fri, Nov 28, 2014 at
> > > >> 4:36 PM, Dexuan Cui <decui@microsoft.com>  >> wrote:
> > > >>  >>  >>  -----Original Message-----  >>  >>  From: Jason Wang
> > > >> [mailto:jasowang@redhat.com]  >>  >>  Sent: Friday, November 28,
> > > >> 2014 14:47 PM  >>  >>  To: Dexuan Cui  >>  >>  Cc:
> > > >> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;  >>  >>
> > > >> driverdev-  >>  >>  devel@linuxdriverproject.org; olaf@aepfle.de;
> > > >> >> apw@canonical.com; KY  >>  >>  Srinivasan; vkuznets@redhat.com;
> > > >> Haiyang Zhang  >>  >>  Subject: Re: [PATCH v3] hv: hv_fcopy: drop
> > > >> the obsolete message  >> on  >>  >> transfer  >>  >>  failure  >>
> > > >> >>  On Thu, Nov 27, 2014 at 9:09 PM, Dexuan Cui  >>
> > > >> <decui@microsoft.com>  >>  >> wrote:
> > > >>  >>  >>  > In the case the user-space daemon crashes, hangs or is
> > > >> >> killed, we  >>  >>  > need to down the semaphore, otherwise,
> > > >> after the daemon starts  >>  >> next  >>  >>  > time, the obsolete
> > > >> data in fcopy_transaction.message or  >>  >>  >
> > > >> fcopy_transaction.fcopy_msg will be used immediately.
> > > >>  >>  >>  >
> > > >>  >>  >>  > Cc: Jason Wang <jasowang@redhat.com>  >>  >>  > Cc:
> > > >> Vitaly Kuznetsov <vkuznets@redhat.com>  >>  >>  > Cc: K. Y.
> > > >> Srinivasan <kys@microsoft.com>  >>  >>  > Signed-off-by: Dexuan Cui
> > > >> <decui@microsoft.com>  >>  >>  > ---  >>  >>  >  >>  >>  > v2: I
> > > >> removed the "FCP" prefix as Greg asked.
> > > >>  >>  >>  >
> > > >>  >>  >>  >     I also updated the output message a little:
> > > >>  >>  >>  >     "FCP: failed to acquire the semaphore" -->
> > > >>  >>  >>  >     "can not acquire the semaphore: it is benign"
> > > >>  >>  >>  >
> > > >>  >>  >>  > v3: I added the code in fcopy_release() as Jason Wang
> > > >> >> suggested.
> > > >>  >>  >>  >     I removed the pr_debug (it isn't so meaningful)and
> > > >> added a
> > > >>  >>  >>  > comment instead.
> > > >>  >>  >>  >
> > > >>  >>  >>  >  drivers/hv/hv_fcopy.c | 19 +++++++++++++++++++  >>  >>
> > > >> >  1 file changed, 19 insertions(+)  >>  >>  >  >>  >>  > diff
> > > >> --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c  >>  >>  >
> > > >> index 23b2ce2..faa6ba6 100644  >>  >>  > ---
> > > >> a/drivers/hv/hv_fcopy.c  >>  >>  > +++ b/drivers/hv/hv_fcopy.c  >>
> > > >> >>  > @@ -86,6 +86,18 @@ static void fcopy_work_func(struct  >>
> > > >> work_struct  >>  >>  > *dummy)
> > > >>  >>  >>  >   * process the pending transaction.
> > > >>  >>  >>  >   */
> > > >>  >>  >>  >  fcopy_respond_to_host(HV_E_FAIL);
> > > >>  >>  >>  > +
> > > >>  >>  >>  > +/* In the case the user-space daemon crashes, hangs
> > or
> > > >> is
> > > >>  >>  >> killed, we
> > > >>  >>  >>  > + * need to down the semaphore, otherwise, after
> > the
> > > >> daemon
> > > >>  >>  >> starts
> > > >>  >>  >>  > next
> > > >>  >>  >>  > + * time, the obsolete data in
> > fcopy_transaction.message
> > > >> or
> > > >>  >>  >>  > + * fcopy_transaction.fcopy_msg will be used
> > immediately.
> > > >>  >>  >>  > + *
> > > >>  >>  >>  > + * NOTE: fcopy_read() happens to get the
> > semaphore (very
> > > >>  >> rare)?
> > > >>  >>  >>  > We're
> > > >>  >>  >>  > + * still OK, because we've reported the failure to the
> > > >> host.
> > > >>  >>  >>  > + */
> > > >>  >>  >>  > +if (down_trylock(&fcopy_transaction.read_sema))
> > > >>  >>  >>  > +;
> > > >>  >>  >>
> > > >>  >>  >>  Sorry, I'm not quite understand how if () ; can help here.
> > > >>  >>  >>
> > > >>  >>  >>  Btw, a question not relate to this patch.
> > > >>  >>  >>
> > > >>  >>  >>  What happens if a daemon is resume from SIGSTOP and
> > > >> expires the  >>  >> check  >>  >>  here?
> > > >>  >>  > Hi Jason,
> > > >>  >>  > My idea is: here we need down_trylock(), but in case we
> > > >> can't get  >> the  >>  > semaphore, it's OK anyway:
> > > >>  >>  >
> > > >>  >>  > Scenario 1):
> > > >>  >>  > 1.1: when the daemon is blocked on the pread(), the daemon
> > > >> >> receives  >>  > SIGSTOP;  >>  > 1.2: the host user runs the
> > > >> PowerShell Copy-VMFile command;  >>  > 1.3.1: the driver reports
> > > >> the failure to the host user in 5s and  >>  > 1.3.2: the driver
> > > >> down()-es the semaphore;  >>  > 1.4: the daemon receives SIGCONT
> > > >> and it will be still blocked on  >> the  >>  > pread().
> > > >>  >>  > Without the down_trylock(), in 1.4, the daemon can receive
> > > >> an  >>  > obsolete message.
> > > >>  >>  > NOTE: in this scenario, the daemon is not killed.
> > > >>  >>  >
> > > >>  >>  > Scenario 2):
> > > >>  >>  > In senario 1), if the daemon receives SIGCONT between 1.3.1
> > > >> and  >> 1.3.2  >>  > and  >>  > do down() in fcopy_read(), it will
> > > >> receive the message but:
> > > >> the
> > > >>  >>  > driver has
> > > >>  >>  > reported the failure to the host user and the driver's 1.3.2
> > > >> can't  >>  > get the  >>  > semaphore -- IMO this is acceptably OK,
> > > >> though in the VM, an  >>  > incomplete  >>  > file will be left
> > > >> there.
> > > >>  >>  > BTW, I think in the daemon's hv_start_fcopy() we should add
> > > >> a  >>  > close(target_fd) before open()-ing a new one.
> > > >>  >>
> > > >>  >>  Right, but how about the case when resuming from SIGSTOP but
> > > >> no  >> timeout?
> > > >>  > Sorry, I don't understand this:
> > > >>  > if no timeout, fcopy_read() will get the semaphore and
> > > >> fcopy_write()
> > > >>  > will try to cancel fcopy_work.
> > > >>
> > > >>  Yes.
> > > >>  >
> > > >>  >
> > > >>  >>  Looks like in this case userspace() may wait in
> > > >> down_interruptible()
> > > >>  >>  until timeout. We probably need something like this:
> > > >>  >>
> > > >>  >>          if (down_interruptible(&fcopy_transaction.read_sema)) {
> > > >>  >>                  up(&fcopy_transaction.read_sema);
> > > >>  >>                  return -EINTR;
> > > >>  >>          }
> > > >>  > until "timeout"?
> > > >>  > if the daemon can't get the semaphore, it can only be wake by a
> > > >> > signal(the  > daemon doesn't install handler, so by default most
> > > >> signals will kill  > the daemon).
> > > >>  > In case a signal waking up the daemon doesn't kill the daemon,
> > > >> why  > should  > we do up()?
> > > >>
> > > >>  True, no need since we do down_trylock() in release().
> > > >>
> > > >>  Btw, there's no EINTR handling in handling pread() return value,
> > > >> may add such one which should be useful for something like
> > > >> debugging.
> > > >>
> > > >>  >
> > > >>  >
> > > >>  >>
> > > >>  >>  This should synchronize with the timeout work for sure.
> > > >>  >>  But how about only schedule it after this?
> > > >>  >>  It does not may sense to start the timer during interrupt  >>
> > > >> since the file may not even opened and it may take time  >>  to
> > > >> handle signals?
> > > >>  >>
> > > >>  >>  >
> > > >>  >>  >>  >
> > > >>  >>  >>  > +
> > > >>  >>  >>  >  }
> > > >>  >>  >>  >
> > > >>  >>  >>  >  static int fcopy_handle_handshake(u32 version)  >>  >>
> > > >> > @@ -351,6 +363,13 @@ static int fcopy_release(struct inode  >>
> > > >> *inode,  >>  >>  > struct file *f)
> > > >>  >>  >>  >   */
> > > >>  >>  >>  >  in_hand_shake = true;
> > > >>  >>  >>  >  opened = false;
> > > >>  >>  >>  > +
> > > >>  >>  >>  > +if (cancel_delayed_work_sync(&fcopy_work)) {
> > > >>  >>  >>  > +/* We haven't up()-ed the semaphore(very
> > rare)? */
> > > >>  >>  >>  > +if
> > (down_trylock(&fcopy_transaction.read_sema))
> > > >>  >>  >>  > +;
> > > >>  >>  >>
> > > >>  >>  >>  And this.
> > > >>  >>  >
> > > >>  >>  > Scenario 3):
> > > >>  >>  > When the daemon exits(e.g., SIGKILL received), if there is a
> > > >> >>  > fcopy_work  >>  > pending (scheduled but not start to run
> > > >> yet), we should cancel the  >>  > work (as you suggested) and
> > > >> down() the semaphore, otherwise, the  >>  > obsolete message will
> > > >> be received by the next instance of the  >> daemon.
> > > >>  >>
> > > >>  >>  Yes
> > > >>  >>  >
> > > >>  >>  >
> > > >>  >>  > Scenario 4):  in the driver's hv_fcopy_onchannelcallback():
> > > >>  >>  >         schedule_delayed_work(&fcopy_work, 5*HZ);
> > > >>  >>  >         ----> if fcopy_release() is running on another vcpu,
> > > >> just
> > > >>  >>  > before the next line?
> > > >>  >>  >         fcopy_send_data();
> > > >>  >>  >
> > > >>  >>  > In this case, fcopy_release() can cancel fcopy_work, but  >>
> > > >> > can't get the semaphore since it hasn't been up()-ed.
> > > >>  >>  > Hmm, in this case,   fcopy_send_data() will do up()  later,
> > > >> and
> > > >>  >> we'll
> > > >>  >>  > buffer an obsolete message in the driver, and the message
> > > >> will be  >>  > fetched by the next instance of the daemon...
> > > >>  >>  >
> > > >>  >>  > Looks we need a spinlock here?
> > > >>  >>
> > > >>  >>  Unless fcopy_release() can wait for all data for current
> > > >> transation  >>  to be received. Spinlock won't help.
> > > >>  >>
> > > >>  >>  But an idea is let the daemon the handle such cases. E.g make
> > > >> sure  >> the  >>  processing begins with START_COPY and end with
> > > >> COMPLETE/CANCEL_COPY.
> > > >>  >>  Drop all requests that does not start with START_COPY.
> > > >>  >>
> > > >>  >>  Thought?
> > > >>  > Good idea.
> > > >>  > I also think we should reinforce the concept of state machine in
> > > >> the  > daemon code.
> > > >>
> > > >>  Yes, it needs.
> > > > I agree.
> > > > Obviously we can do something to make the daemon/driver work better
> > > > in the corner cases.
> > > >
> > > >>  >
> > > >>  > The daemon/driver communication has so many corner cases...
> > > >>
> > > >>  Looks so, let's first address the issue mentioned in this patch.
> > > > OK.
> > > >
> > > >>  I don't have any more comments other than changing
> > > >>
> > > >>   if(down_trylock(&fcopy_transaction.read_sema))
> > > >>       ;
> > > >>
> > > >>  to
> > > >>
> > > >>  down_trylock(&fcopy_transaction.read_sema);
> > > > Hi Jason,
> > > > This is to address Vitaly's comment in the bugzilla:
> > > > https://bugzilla.redhat.com/show_bug.cgi?id=1162100#c5
> > > >
> > > > down_trylock(&fcopy_transaction.read_sema) will
> > > >
> > > > "
> > > > produces the following compile warning:
> > > > drivers/hv/hv_fcopy.c: In function ‚Äòfcopy_work_func‚Äô:
> > > > drivers/hv/hv_fcopy.c:95:2: warning: ignoring return value of
> > > > ‚Äòdown_trylock‚Äô, declared with attribute warn_unused_result
> > > > [-Wunused-result]
> > > >   (void)down_trylock(&fcopy_transaction.read_sema);
> > > > "
> > > >
> > > > Actually I personally don't care about the warning, because we only
> > > > see it when we run some kind of code checker program.  :-)
> > > >
> > > > I can change my v3  to the "normal" style you prefer, if there is no
> > > > strong objection from Vitaly?
> > >
> > > Ah, I see the point. Then no objection for this patch.
> > >
> > > Since Vitaly said he does not has objection.
> > >
> > > Acked-by: Jason Wang <jasowang@redhat.com>
> >
> > I realized non-trivial effort might be needed to better handle corner cases.
> > This is only the first step.
> >
> > E.g., I found a new corner case:
> > after we unload the hv_utils/fcopy driver, the fcopy daemon can exit and
> > fcopy_release() will be invoked -- at this time fcopy_release() has become
> > obsolete and invalid, and as a result, a kernel panic can happen:  I did see
> the
> > panic once.
> 
> You should not be able to unload the driver when there is still an open
> reference from the
> Daemon.
> 
> K. Y

Hi KY, I'm able to reproduce the below issue every time:
(I ran the below in Ubuntu 14.10 but I think we're able to repro it in any distro):

1) start hv_fcopy_daemon and use ps to make sure it's running in the background;
2) kill -STOP `pidof hv_fcopy_daemon`, and use ps to make sure the daemon is in
the state of "Ts";
3) rmmod hv_utils  # dexuan: this can runs fine. 
4) kill -CONT `pidof hv_fcopy_daemon` and we see an oops at once:

[ 9699.421564] BUG: unable to handle kernel paging request at ffffffffc019c230
[ 9699.422701] IP: [<ffffffff811de294>] filp_close+0x24/0x70
[ 9699.423154] PGD 1c16067 PUD 1c18067 PMD 366d8067 PTE 0
[ 9699.423154] Oops: 0000 [#1] SMP
[ 9699.423154] Modules linked in: hv_utils rfcomm bnep bluetooth 6lowpan_iphc joydev hid_generic crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd hid_hyperv serio_raw hid hyperv_keyboard hv_balloon mac_hid hyperv_fb i2c_piix4 parport_pc ppdev lp parport hv_storvsc psmouse floppy hv_vmbus tulip pata_acpi [last unloaded: hv_utils]
[ 9699.423154] CPU: 0 PID: 4659 Comm: hv_fcopy_daemon Not tainted 3.16.0-23-generic #31-Ubuntu
[ 9699.423154] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[ 9699.423154] task: ffff880019ce5bb0 ti: ffff8800c7be0000 task.ti: ffff8800c7be0000
[ 9699.423154] RIP: 0010:[<ffffffff811de294>]  [<ffffffff811de294>] filp_close+0x24/0x70
[ 9699.423154] RSP: 0018:ffff8800c7be3e48  EFLAGS: 00010246
[ 9699.423154] RAX: ffffffffc019c1c0 RBX: ffff8800c7b9c200 RCX: ffff8800396548d8
[ 9699.423154] RDX: 0000000080000000 RSI: ffff880039654880 RDI: ffff8800c7b9c200
[ 9699.423154] RBP: ffff8800c7be3e60 R08: 0000000000000001 R09: 00000001802a0017
[ 9699.423154] R10: ffff88003de17640 R11: ffff880087963140 R12: 0000000000000000
[ 9699.423154] R13: ffff880039654880 R14: ffff880039654890 R15: 0000000000000004
[ 9699.423154] FS:  0000000000000000(0000) GS:ffff88003de00000(0000) knlGS:0000000000000000
[ 9699.423154] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9699.423154] CR2: ffffffffc019c230 CR3: 0000000001c13000 CR4: 00000000001406f0
[ 9699.423154] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9699.423154] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 9699.423154] Stack:
[ 9699.423154]  0000000000000001 0000000000000000 ffff880039654880 ffff8800c7be3ea0
[ 9699.423154]  ffffffff811ff208 00000001034a4c80 ffff880019ce5bb0 ffff880039654880
[ 9699.423154]  ffff880019ce6308 ffff8800126b8e00 ffff8800126b8e60 ffff8800c7be3ec8
[ 9699.423154] Call Trace:
[ 9699.423154]  [<ffffffff811ff208>] put_files_struct+0x78/0xd0
[ 9699.423154]  [<ffffffff811ff307>] exit_files+0x47/0x50
[ 9699.423154]  [<ffffffff810725a7>] do_exit+0x357/0xab0
[ 9699.423154]  [<ffffffff81072d83>] do_group_exit+0x43/0xc0
[ 9699.423154]  [<ffffffff81072e14>] SyS_exit_group+0x14/0x20
[ 9699.423154]  [<ffffffff81787ced>] system_call_fastpath+0x1a/0x1f
[ 9699.423154] Code: ff ff 0f 1f 44 00 00 0f 1f 44 00 00 55 48 89 e5 41 55 41 54 53 48 8b 47 38 48 89 fb 48 85 c0 74 46 48 8b 47 28 45 31 e4 49 89 f5 <48> 8b 40 70 48 85 c0 74 05 ff d0 41 89 c4 f6 43 45 40 75 16 4c
[ 9699.423154] RIP  [<ffffffff811de294>] filp_close+0x24/0x70
[ 9699.423154]  RSP <ffff8800c7be3e48>
[ 9699.423154] CR2: ffffffffc019c230
[ 9699.423154] ---[ end trace 0278723740833669 ]---
[ 9699.423154] Fixing recursive fault but reboot is needed!

I understand an administrator should not unload the driver before stopping the
daemon, but this could happen by accident.

 -- Dexuan

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
