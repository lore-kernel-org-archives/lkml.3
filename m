Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3IWL3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 07:29:30 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:34707 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753126Ab3IWL33 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:29:29 -0400
X-Greylist: delayed 1110 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Sep 2013 07:29:18 EDT
X-ASG-Debug-ID: 1379934644-053ea958901914d0001-xx1T2L
X-Barracuda-Envelope-From: Amit.Phansalkar@hgst.com
From: Amit Phansalkar <Amit.Phansalkar@hgst.com>
To: Jens Axboe <axboe@kernel.dk>, Olof Johansson <olof@lixom.net>
CC: Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>,
        OS Engineering <osengineering@stec-inc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Akhil Bhansali <Akhil.Bhansali@hgst.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>
Subject: RE: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
Thread-Topic: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
X-ASG-Orig-Subj: RE: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
Thread-Index: AQHOqi+Qh7EXiNWKSmiiNkzvW8Lqcpm2qVYAgBMtmQCAABVogIAE23gAgAFocQCAAcTtgIAAAuWAgAFLuFA=
Date: Mon, 23 Sep 2013 11:09:40 +0000
Message-ID: <9E0FBE8B4A495047BEC0E5E7D56EB0601290A7@MYMBX3.stec-inc.ad>
References: <26D762E250385C4D8E9D6EC3C8E47DC11E6FCF20@sambx4.stec-inc.ad>
 <x49vc2nnwp5.fsf@segfault.boston.devel.redhat.com>
 <26D762E250385C4D8E9D6EC3C8E47DC11E6FE729@sambx4.stec-inc.ad>
 <x4938pjbhqk.fsf@segfault.boston.devel.redhat.com>
 <5228913A.50807@kernel.dk>
 <CAOesGMhF42=qQLyMyF4-tsTjCxwX0bb10rTQv9sLooyzrEOpHA@mail.gmail.com>
 <5238B9A7.6040002@kernel.dk>
 <20130920153128.63244ec2658b7ad3aee0e2e4@linux-foundation.org>
 <20130921200132.GF2312@kernel.dk>
 <CAOesGMg2t551P7a1wa=FkTjgDaeXedCej87oi+yF2c3Q-hoP5g@mail.gmail.com>
 <20130922231259.GG31014@kernel.dk>
In-Reply-To: <20130922231259.GG31014@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.20.20.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas03.stec-inc.ad[172.30.8.21]
X-Barracuda-Start-Time: 1379934644
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140846
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Monday, September 23, 2013 4:43 AM
> To: Olof Johansson
> Cc: Andrew Morton; Jeff Moyer; OS Engineering; linux-
> kernel@vger.kernel.org; Akhil Bhansali; Ramprasad Chinthekindi; Amit
> Phansalkar
> Subject: Re: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
> 
> On Sun, Sep 22 2013, Olof Johansson wrote:
> > On Sat, Sep 21, 2013 at 1:01 PM, Jens Axboe <axboe@kernel.dk> wrote:
> > > On Fri, Sep 20 2013, Andrew Morton wrote:
> > >> On Tue, 17 Sep 2013 14:20:55 -0600 Jens Axboe <axboe@kernel.dk>
> wrote:
> > >>
> > >> > > So, it looks like this driver needs a bunch of work before it's
> > >> > > ready to go in. Or, maybe it's better to submit it with a TODO
> > >> > > list for the staging tree instead?
> > >> >
> > >> > Not disagreeing with you, it definitely needs a bit of cleaning.
> > >> > And so far stec has not been very responsive in fixing those issues.
> > >>
> > >> Geeze.  Here's what I came up with, mainly to make i386 compile:
> > >
> > > Thanks Andrew. It's not the fixes themselves that are tricky, I
> > > would just have liked a little more proof that the submission wasn't
> > > just a dump'n run.
> >
> > Well, that's what much of the staging process is about, since it needs
> > to come with a todo list (and that list needs to be taken care of
> > before the driver graduates). Honestly, this looks like a prime
> > candidate for that. But it's your tree and your call.
> >
> > Thanks for applying the patch from Andrew, that resolves most of it
> > for me right now.
> 
> I'm sort-of on the fence. It's minor stuff, but it does need cleaning up. So not
> necessarily something that will prevent it from going into 3.12, it's more the
> continued support and development I'm worried about.
> 

Hi Jens,

My name is Amit and I'm managing the host drivers team at sTec (now HGST). 

Thank you for your continued support and feedback in this effort. We are really committed to support this driver as part of Linux open source/kernel. I'd like to assure you that this is not a dump and run submission. In the recent past, we were working with Jeff to get this driver ready for open source and have been making necessary revisions. Even in future, my team would be available to investigate the issues and patch the driver accordingly. It would be great if you could consider this driver for 3.12 inclusion. 

Thanks and regards,
Amit Phansalkar


> --
> Jens Axboe


PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
