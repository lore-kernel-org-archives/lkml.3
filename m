Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab3HGVKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:10:00 -0400
Received: from mx12.netapp.com ([216.240.18.77]:54131 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933197Ab3HGVJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:09:57 -0400
X-IronPort-AV: E=Sophos;i="4.89,835,1367996400"; 
   d="scan'208";a="79425490"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Nix <nix@esperi.org.uk>
CC: Jeff Layton <jlayton@redhat.com>,
        =?utf-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, NFS list <linux-nfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>
Subject: Re: [3.10.4] NFS locking panic, plus persisting NFS shutdown panic
 from 3.9.*
Thread-Topic: [3.10.4] NFS locking panic, plus persisting NFS shutdown panic
 from 3.9.*
Thread-Index: AQHOk7FH4gcyFEImq0mWTcGQZbqon5mKsuSA
Date: Wed, 7 Aug 2013 21:09:55 +0000
Message-ID: <1375909795.7280.58.camel@leira.trondhjem.org>
References: <8761vlv4z9.fsf@spindle.srvr.nix>
	 <20130805084436.69ee4415@corrin.poochiereds.net>
	 <87siyotcri.fsf@spindle.srvr.nix>
	 <20130805110427.509db424@tlielax.poochiereds.net>
	 <20130805111106.73d6ab90@tlielax.poochiereds.net>
	 <87zjswrvaq.fsf@spindle.srvr.nix>
	 <1375719301.7337.14.camel@leira.trondhjem.org>
	 <20130805133739.21654ecb@tlielax.poochiereds.net>
	 <1375726682.7337.29.camel@leira.trondhjem.org>
	 <20130805143311.4ae59067@tlielax.poochiereds.net>
	 <1375755693.7337.42.camel@leira.trondhjem.org>
	 <87iozhst0s.fsf@spindle.srvr.nix>
	 <1375889252.6488.1.camel@leira.trondhjem.org>
	 <87iozhmd0a.fsf@spindle.srvr.nix>
In-Reply-To: <87iozhmd0a.fsf@spindle.srvr.nix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EB5FAA5D457F844A01DD8C3D63EB233@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r77LA6gv029527

On Wed, 2013-08-07 at 22:01 +0100, Nix wrote:
> On 7 Aug 2013, Trond Myklebust said:
> 
> > On Wed, 2013-08-07 at 11:18 +0100, Nix wrote:
> >> On 6 Aug 2013, Trond Myklebust verbalised:
> >> > True. How about something like the following instead. Note the change to
> >> > the original patch...
> >> 
> >> Well, with those applied I could reboot without a panic for the first
> >> time since 3.8.x: looking good. I'll give it a reboot or two with a
> >> system that's not hot from booting though.
> >
> > Could you please also try applying only the 1/2 patch, to see if that
> > suffices to quell the shutdown panic?
> 
> It doesn't suffice. I see this severely truncated oops:
> 
> [  115.799092] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [  115.800284] IP: [<ffffffff81165ec6>] path_init+0x11c/0x36f
> [  115.801463] PGD 0 
> [  115.802625] Oops: 0000 [#1] PREEMPT SMP 
> [  115.803805] Modules linked in: [last unloaded: microcode] 
> [  115.804995] CPU: 3 PID: 1191 Comm: sleep Not tainted 3.10.5-05317-g3c9f6fa-dirty #2
> [  115.806207] Hardware name: System manufacturer System Product Name/P8H61-MX USB3, BIOS 0506 08/10/2012
> [  115.807453] task: ffff8804189a0000 ti: ffff8803f74d6000 task.ti: ffff8803f74d6000
> 
OK. Then I'll mark them both for stable inclusion in 3.9+.

Thanks for testing!
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
