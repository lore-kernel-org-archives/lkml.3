Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725Ab3GSOkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:40:00 -0400
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:59056
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509Ab3GSOj4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:39:56 -0400
X-Forefront-Antispam-Report: CIP:192.65.42.18;KIP:(null);UIP:(null);IPV:NLI;H:mx.danahertm.com;RD:mx.danahertm.com;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(z21eIz98dI9371I146fI542I1432I1418I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz4ejz1de098h17326ah1de097h1de096h8275dhz2dh2a8h668h839h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
From: "Rich, Jason" <jason.rich@tekcomms.com>
To: "Rich, Jason" <jason.rich@tekcomms.com>, Willy Tarreau <w@1wt.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Panic at _blk_run_queue on 2.6.32
Thread-Topic: Panic at _blk_run_queue on 2.6.32
Thread-Index: Ac58y6RwiDajJiLlQbi1pm9xZ49xQgBCipKAAOOG4PAAyj6RYA==
Date: Fri, 19 Jul 2013 14:38:45 +0000
Message-ID: <636295BFF4A001418A00F46569A2CD2B161EEE7E@US-PLNO-EXM01-P.global.tektronix.net>
References: <636295BFF4A001418A00F46569A2CD2B161CE88B@US-PLNO-EXM01-P.global.tektronix.net>
 <20130710202729.GA18877@1wt.eu>
 <636295BFF4A001418A00F46569A2CD2B161DF7B0@US-PLNO-EXM01-P.global.tektronix.net>
In-Reply-To: <636295BFF4A001418A00F46569A2CD2B161DF7B0@US-PLNO-EXM01-P.global.tektronix.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.158.160.99]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: tekcomms.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Rich, Jason
> Sent: Monday, July 15, 2013 9:10 AM
> To: Willy Tarreau
> Cc: linux-kernel@vger.kernel.org
> Subject: RE: Panic at _blk_run_queue on 2.6.32
> 
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Willy Tarreau
> > Sent: Wednesday, July 10, 2013 3:27 PM
> > To: Rich, Jason
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Re: Panic at _blk_run_queue on 2.6.32
> >
> > Hi Jason,
> >
> > On Tue, Jul 09, 2013 at 05:42:29PM +0000, Rich, Jason wrote:
> > > Greetings,
> > > I've recently encountered an issue where multiple hosts are failing
> > > to boot up about 1/5 of the time.  So far I have confirmed this
> > > issue on three
> > seperate host machines.  The issue presents itself after updating
> > 2.6.32.39 to patch 50 and patch 61.
> > > Both patch levels result in the failure described below.  Since this
> > > occurs on
> > multiple hosts, I feel I can safely rule out hardware.
> >
> > First, thank you for your very detailed report. Do you think you could
> > narrow this down to a specific kernel version ? Given that there are
> > exactly 10 versions between .39 and .50, I think that a version-level
> > bisect would take
> > 3 or 4 builds (so probably around 20 reboots).
> 
> I was out of town for a little while there, but I plan to do just that in a little
> while.  I will let you know what I find.  Hopefully it won't take me too terribly
> long.
> 
> >
> > It would help us spot the faulty patch. Right now, there are 546
> > patches between .39 and .50 so it's quite hard to find the culprit,
> > even with your full trace. That does not mean we'll immediately spot
> > it, maybe a deeper bisect will be needed, but it should be easier.
> >
> > > It is also of note that I have not seen this behavior on the 3.4.26
> > > kernel, or
> > on any of my 32bit hosts.
> >
> > This is a good news, because we're probably missing one fix from a
> > more recent version that addressed a similar regression and that we
> > might backport into 2.6.32.62.
> >
> > > That said, I have to support this software release (which runs on
> > > the 2.6
> > kernel) for at least another two years.
> >
> > Be careful on this point, 2.6.32 is planned for EOL next year :
> >
> >    https://www.kernel.org/category/releases.html
> >
> > You might want to consider migrating to a supported distro kernel or
> > to 3.2 instead. That said, if you follow carefully the updates from
> > later kernels, you might prefer to maintain your own backports of the
> > patches that are relevant to your usage.
> 
> Thanks, we already have pulled in 3.4 to our released product, but I still have
> to support my product's previous releases for a time.  My goal is to patch up
> to .61 plus a fix to this issue and never touch the release again.   Worst case,
> I'll stay on 2.6.32.39 and cherry pick.  I'd really hate to do that, however.
> Anyway, as stated earlier, I'll bisect and try to narrow this down.  Appreciate
> the help so far and really hope we just have to back patch a fix.
> 
> Jason
> >
> > Best regards,
> > Willy
> >

Just a small update from this week of trying to narrow it down.  Long story short I've gotten about 3 bisects in.  The failures are appearing less often than previously seen on these two particular machines.  It feels like maybe 1/40 reboots.  In any case, finding a "good" revision of kernel code will require me to run my test at least overnight to be sure.  My test is a simple reboot the system every 5 minutes.  When it crashes, I have a terminal window open to show it hung up.
In case you are actively poking around, I've ruled out quite a bit so far.  If I understand bisect correctly (this is my first time to use it actually), it took me below 2.6.32.42's tag. 
Bisect log:
# bad: [60b1e4f20a6cf45f07d2aef7eecd7fd58007ff1e] Linux 2.6.32.50
# good: [145fff1f0b75c8bd6a26052d638276bb2e009983] Linux 2.6.32.39
git bisect start 'v2.6.32.50' 'v2.6.32.39'
# bad: [1ff36a0e02f978e533b13ce6a86ad6a73444cec8] cfq-iosched: fix locking around ioc->ioc_data assignment
git bisect bad 1ff36a0e02f978e533b13ce6a86ad6a73444cec8
# bad: [1183c16343f6daff3e418f8c782ce924f52ae148] tehuti: Firmware filename is tehuti/bdx.bin
git bisect bad 1183c16343f6daff3e418f8c782ce924f52ae148
# bad: [0ec1c448546ccd6413dd864bf007a13a3af4c7c4] SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)
git bisect bad 0ec1c448546ccd6413dd864bf007a13a3af4c7c4

> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


