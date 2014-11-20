Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbaKTNjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:39:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:42170 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaKTNji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:39:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,424,1413270000"; 
   d="scan'208";a="635184416"
From: "Liang, Kan" <kan.liang@intel.com>
To: Stephane Eranian <eranian@google.com>, Namhyung Kim <namhyung@kernel.org>
CC: "acme@kernel.org" <acme@kernel.org>, "jolsa@redhat.com" <jolsa@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V4 1/3] perf tools: enable LBR call stack support
Thread-Topic: [PATCH V4 1/3] perf tools: enable LBR call stack support
Thread-Index: AQHQBIuwODa7l2FB7kKmHK6r8bJvrpxo7lAAgACVydA=
Date: Thu, 20 Nov 2014 13:39:26 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701672911@SHSMSX103.ccr.corp.intel.com>
References: <1416346617-3577-1-git-send-email-kan.liang@intel.com>
	<1416346617-3577-2-git-send-email-kan.liang@intel.com>
	<87r3wzpt4o.fsf@sejong.aot.lge.com>
	<37D7C6CF3E00A74B8858931C1DB2F07701671D25@SHSMSX103.ccr.corp.intel.com>
	<871toypelb.fsf@sejong.aot.lge.com>
 <CABPqkBS1a6X4J9Asov=xiax03OnC-R9M9y1Whhg=fBXeTBGGbA@mail.gmail.com>
In-Reply-To: <CABPqkBS1a6X4J9Asov=xiax03OnC-R9M9y1Whhg=fBXeTBGGbA@mail.gmail.com>
Accept-Language: zh-CN, en-US
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAKDdkuG010617



> 
> On Thu, Nov 20, 2014 at 7:32 AM, Namhyung Kim <namhyung@kernel.org>
> wrote:
> >
> > On Wed, 19 Nov 2014 14:32:08 +0000, Kan Liang wrote:
> > >> On Tue, 18 Nov 2014 16:36:55 -0500, kan liang wrote:
> > >> > +                  if (attr->exclude_user) {
> > >> > +                          attr->exclude_user = 0;
> > >> > +
> > >> > +                          pr_warning("LBR callstack option is only available"
> > >> > +                                     " to get user callchain information."
> > >> > +                                     " Force exclude_user to 0.\n");
> > >> > +                  }
> > >>
> > >> I'm not sure what's in a higher priority - maybe I missed earlier
> discussion.
> > >> IOW what about this?
> > >>
> > >>                      if (attr->exclude_user) {
> > >>                              pr_warning("LBR callstack option is only available"
> > >>                                         " to get user callchain
> > >> information.\n");
> > >
> > > I think either is fine. I'd like to add more info "Falling back to
> framepointers."
> > > based on your changes.
> > > So the user know what they will get then.
> > >
> > > What do you think?
> >
> > Looks good to me.  But I still slightly prefer not to override user
> > settings.  But it's not a strong opinion though - I'd like to here
> > from others.
> >
> I don't like when the tool changes the use settings under the hood.
> I think perf did that with cycles -> TASK_CLOCK if PMU was not supported
> and that was very confusing to me especially with no warning.
> So if LBR Call stack mode is not avail, then inform the user with a warning or
> error, don't swap silently.

OK. So the new patch will warn the user if LBR call stack is no available.
It will also tell the user that the FP mode will replace the LBR mode.

Thanks,
Kan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
