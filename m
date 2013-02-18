Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab3BRG0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:26:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:30494 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab3BRG0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:26:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,684,1355126400"; 
   d="scan'208";a="287012753"
From: "Li, Fei" <fei.li@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Miklos Szeredi <miklos@szeredi.hu>
CC: Pavel Machek <pavel@ucw.cz>, Goswin von Brederlow <goswin-v-b@web.de>,
        "Brown, Len" <len.brown@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Wang, Biao" <biao.wang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: Getting rid of freezer for suspend [was Re: [fuse-devel]
 [PATCH] fuse: make fuse daemon frozen along with kernel threads]
Thread-Topic: Getting rid of freezer for suspend [was Re: [fuse-devel]
 [PATCH] fuse: make fuse daemon frozen along with kernel threads]
Thread-Index: AQHOB3olAHFPqtS62k684yYjcBqH9ZhylloAgAAImICAAExEgIAATRqAgACy/QCAACDEAIAAHwMAgAFcLwCAACkpgIAAARWAgAHaHwCAAD9mgIAA34sAgAAZE4CAABBvAIAASu8AgAXb/VA=
Date: Mon, 18 Feb 2013 06:26:34 +0000
Message-ID: <BEC9F67575FA1E429CA7CF5AE9BE3634400F30@SHSMSX102.ccr.corp.intel.com>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <2891124.QXsiBPuYKW@vostro.rjw.lan>
 <CAJfpeguV5X1pwb-E7vzVtK4n0Q6Mu6A4XKnS5-tWn4Q7MtzgZg@mail.gmail.com>
 <6332427.iqPUMjtDaQ@vostro.rjw.lan>
In-Reply-To: <6332427.iqPUMjtDaQ@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1I6Qmvd022141


> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Friday, February 15, 2013 1:38 AM
> To: Miklos Szeredi
> Cc: Pavel Machek; Goswin von Brederlow; Li, Fei; Brown, Len;
> mingo@redhat.com; peterz@infradead.org; Wang, Biao;
> linux-pm@vger.kernel.org; fuse-devel@lists.sourceforge.net;
> linux-kernel@vger.kernel.org; Liu, Chuansheng
> Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH] fuse:
> make fuse daemon frozen along with kernel threads]
> 
> On Thursday, February 14, 2013 02:09:50 PM Miklos Szeredi wrote:
> > On Thu, Feb 14, 2013 at 1:11 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Thursday, February 14, 2013 11:41:16 AM Miklos Szeredi wrote:
> >
> > >>
> > >> It is essentially the same mechanism that is used to delay the
> > >> freezing of kernel threads after userspace tasks have been frozen.
> > >> Except it's a lot more difficult to determine which userspace tasks
> > >> need to be suspended late and which aren't.
> > >
> > > Well, I suppose that information is available to user space.
> > >
> > > Do we need an interface for a process to mark itself as PF_FREEZE_LATE or
> > > do we need an interface for one process to mark another process as
> > > PF_FREEZE_LATE, or both?
> >
> > As a first step marking self with PF_FREEZE_LATE and inheriting this
> > flag across fork/clone would work for most cases, I think.
> 
> OK, so we can just have a switch for that in /proc I suppose.

Thanks for feedback and suggestion.

We have ever tried similar idea, expose interface /sys/power/pm_freeze_daemon,
userspace tasks write 1 to this attribute to make itself to be frozen at the same time
with kernel tasks, and it worked in our experiment.

Do you think it's suitable and enough to use such attribute /sys/power/pm_freeze_late, 
or other more suitable place under /proc suggested?
If needed, I can prepare the patch.

Best Regards,
Li Fei

> > Marking an unrelated process would have all sorts of issues: Who has
> > permission to do this?  Won't it be misused to "fix" random freezer
> > issues.
> 
> Yes, that's why I was asking.
> 
> Thanks,
> Rafael
> 
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
