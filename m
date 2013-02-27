Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab3B0J3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 04:29:17 -0500
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:50005 "HELO
	mysmtp1.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932146Ab3B0J3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 04:29:13 -0500
X-ASG-Debug-ID: 1361957342-053ea90dcf331a50001-xx1T2L
X-Barracuda-Envelope-From: sunnikrishnan@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: "Darrick J. Wong" <darrick.wong@oracle.com>
CC: OS Engineering <osengineering@stec-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        =?utf-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>,
        Amit Kale <akale@stec-inc.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "koverstreet@google.com" <koverstreet@google.com>,
        "thornber@redhat.com" <thornber@redhat.com>
Date: Wed, 27 Feb 2013 17:29:00 +0800
Subject: RE: [PATCH] EnhanceIO ssd caching software
Thread-Topic: [PATCH] EnhanceIO ssd caching software
X-ASG-Orig-Subj: RE: [PATCH] EnhanceIO ssd caching software
Thread-Index: Ac4Uao2cWebjvFE1T4GhiZBAaXJmIgAYjkUQ
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0D55E021E0@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6AAF@MYMBX.MY.STEC-INC.AD>
 <20130215203139.GE26292@blackbox.djwong.org>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B0C746B4948@MYMBX.MY.STEC-INC.AD>
 <20130226214528.GC4059@blackbox.djwong.org>
In-Reply-To: <20130226214528.GC4059@blackbox.djwong.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1361957342
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.123741
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1R9TJfY006206

Hi Darrick, 

> -----Original Message-----
> From: Darrick J. Wong [mailto:darrick.wong@oracle.com]
> Sent: Wednesday, February 27, 2013 3:15 AM
> To: Sanoj Unnikrishnan
> Cc: OS Engineering; Greg Kroah-Hartman; LKML; Jens Axboe; ç‹é‡‘æµ¦; Amit
> Kale; dm-devel@redhat.com; koverstreet@google.com; thornber@redhat.com
> Subject: Re: [PATCH] EnhanceIO ssd caching software
> 
> On Mon, Feb 18, 2013 at 05:42:38PM +0800, Sanoj Unnikrishnan wrote:
> > > -----Original Message-----
> > > From: Darrick J. Wong [mailto:darrick.wong@oracle.com]
> > > Sent: Saturday, February 16, 2013 2:02 AM
> > > To: OS Engineering
> > > Cc: Greg Kroah-Hartman; LKML; Jens Axboe; Sanoj Unnikrishnan;
> ç‹é‡‘æµ¦;
> > > Amit Kale; dm-devel@redhat.com; koverstreet@google.com;
> > > thornber@redhat.com
> > > Subject: Re: [PATCH] EnhanceIO ssd caching software
> > >
> > > [Resending with dm-devel, Kent, and Joe on cc.  Sorry for the
> > > noise.]
> > >
> > > On Fri, Feb 15, 2013 at 02:02:38PM +0800, OS Engineering wrote:
> > > > Hi Greg, Jens,
> > > >
> > > > We are submitting EnhanceIO(TM) software driver for an inclusion
> > > > in
> > > linux
> > > > staging tree. Present state of this driver is beta. We have been
> > > posting it
> > > > for a few weeks, while it was maintained at github. It is still
> > > > being cleaned-up and is being tested by LKML members. Inclusion
> in
> > > > linux
> > > staging
> > > > tree will make testing and reviewing easier and help a future
> > > integration in
> > > > Linux kernel.
> > > >
> > > > Could you please include it?
> >
> > > >
> > > > Signed-off-by:
> > > > Amit Kale <akale@stec-inc.com>
> > > > Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com> Darrick J. Wong
> > > > <darrick.wong@oracle.com> Jinpu Wang <jinpuwang@gmail.com>
> > >
> > > Each of these email addresses needs to have the "S-o-b:" prefix
> >
> > > Also, you ought to run this patch through scripts/checkpatch.pl, as
> > > there are quite a lot of style errors.
> >
> > we will fix these in the next patch.
> >
> >
> > > > +       Write-back improves write latency by writing application
> > > requested data
> > > > +       only to SSD. This data, referred to as dirty data, is
> > > > + copied
> > > later to
> > >
> > > How much later?
> > >
> >
> > This is triggered by a set of thresholds.
> > per cache dirty high and low watermark.
> > per cache set dirty high and low watermark.
> > and a time based threshold.
> > If any of the high watermarks or time based interval is triggered
> clean is initiated.
> >
> > These thresholds are all configurable through sysctl.
> 
> Is there a way for a user application to force a cache flush?  It looks
> as though a REQ_FLUSH will cause both SSD and HDD to flush their write
> caches, but I couldn't find anything that would suggest writing all the
> dirty blocks in the cache out to the HDD.


There is a clean command in eio_cli which flushes all the dirty data on user input.
 
Thanks and regards,
Sanoj


PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED

This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
