Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaJ0BnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:43:17 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43734 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbaJ0BnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:43:16 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Dan Streetman <ddstreet@ieee.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 26 Oct 2014 18:43:11 -0700
Subject: RE: [PATCH] drivers: base: update cpu offline info when do hotplug
Thread-Topic: [PATCH] drivers: base: update cpu offline info when do hotplug
Thread-Index: Ac/sh7aCR8NyL9U0QrWhIyu5ivXqegE/zHSA
Message-ID: <9034CBD80F070943B59700D7F8149ED9024ED2A134@SC-VEXCH4.marvell.com>
References: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
 <20141020044340.GA9589@kroah.com>
 <9034CBD80F070943B59700D7F8149ED9024EB81CAF@SC-VEXCH4.marvell.com>
 <20141020064826.GA4064@kroah.com>
 <9034CBD80F070943B59700D7F8149ED9024EB81CC6@SC-VEXCH4.marvell.com>
 <CALZtONDEdFbx+zTWYdmz3HsfCnV+RtTPAuY4p-RK1DN3g2CwrQ@mail.gmail.com>
In-Reply-To: <CALZtONDEdFbx+zTWYdmz3HsfCnV+RtTPAuY4p-RK1DN3g2CwrQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-27_01:2014-10-24,2014-10-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410270018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9R1hMMp002427

Greg,


> -----Original Message-----
> From: ddstreet@gmail.com [mailto:ddstreet@gmail.com] On Behalf Of Dan
> Streetman
> Sent: 2014å¹´10æœˆ21æ—¥ 1:03
> To: Neil Zhang
> Cc: Greg KH; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug
> 
> On Mon, Oct 20, 2014 at 3:40 AM, Neil Zhang <zhangwm@marvell.com> wrote:
> > Greg,
> >
> >
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: 2014å¹´10æœˆ20æ—¥ 14:48
> > To: Neil Zhang
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] drivers: base: update cpu offline info when do
> > hotplug
> >
> > On Sun, Oct 19, 2014 at 11:39:23PM -0700, Neil Zhang wrote:
> >>> How much noise is this going to cause on a big/little system that
> >>> constantly hot unplug/plugs processors all of the time?
> >>
> >> Can you explain more what kind of noise will be introduced on a big/little
> system?
> >
> > Have you tested this on such a machine?
> >
> > I didn't have such kind of machine on hand.
> > Can anyone has such machine to verify it?
> > Thanks!
> 
> I tested this on a ppc PowerVM system, using dlpar operations to remove/add
> cpus.
> 
> Without this patch the cpu online nodes get out of sync with the main online
> node (and the actual state of the cpus), because they aren't updated as the
> cpus are brought up/down:
> 
> [root@br10p02 cpu]$ pwd
> /sys/devices/system/cpu
> [root@br10p02 cpu]$ cat online
> 0-39
> [root@br10p02 cpu]$ for n in {0..47} ; do test $( cat cpu$n/online ) -eq 1 &&
> echo -n "$n " ; done ; echo ""
> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
> 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
> 
> 
> While with the patch, the cpu online nodes are kept up to date as the cpus are
> brought up/down:
> 
> [root@br10p02 cpu]$ pwd
> /sys/devices/system/cpu
> [root@br10p02 cpu]$ cat online
> 0-39
> [root@br10p02 cpu]$ for n in {0..47} ; do test $( cat cpu$n/online ) -eq 1 &&
> echo -n "$n " ; done ; echo ""
> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
> 27 28 29 30 31 32 33 34 35 36 37 38 39
> 
> 
> Feel free to add
> 
> Tested-by: Dan Streetman <ddstreet@ieee.org>
> 

It's a real bug in the kernel.
What's your comments about this patch?

> >
> >> As I know IKS on arm will use cpu_suspend way to power down a core.
> >
> > Are you sure that it also doesn't use that same functionality to drop a
> processor to save power?
> >
> > As I know it use cpu_suspend to switch out a processor in IKS and there is
> no cpu hotplug notifier in this procedure.
> >
> >
> > Why do you need/want this notification?  What are you going to do with this
> information that you don't already have?
> >
> > The offline won't be updated if an in kernel hotplug governor plug in / out
> a core which cause the sysfs interface report a wrong status.
> >
> >
> > thanks,
> >
> > greg k-h
> >
> >
> > Best Regards,
> > Neil Zhang

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
