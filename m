Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbaKTMhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:37:39 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:53952 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbaKTMhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:37:34 -0500
MIME-Version: 1.0
In-Reply-To: <871toypelb.fsf@sejong.aot.lge.com>
References: <1416346617-3577-1-git-send-email-kan.liang@intel.com>
	<1416346617-3577-2-git-send-email-kan.liang@intel.com>
	<87r3wzpt4o.fsf@sejong.aot.lge.com>
	<37D7C6CF3E00A74B8858931C1DB2F07701671D25@SHSMSX103.ccr.corp.intel.com>
	<871toypelb.fsf@sejong.aot.lge.com>
Date: Thu, 20 Nov 2014 13:37:34 +0100
Message-ID: <CABPqkBS1a6X4J9Asov=xiax03OnC-R9M9y1Whhg=fBXeTBGGbA@mail.gmail.com>
Subject: Re: [PATCH V4 1/3] perf tools: enable LBR call stack support
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: "Liang, Kan" <kan.liang@intel.com>, "acme@kernel.org" <acme@kernel.org>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 7:32 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>
> On Wed, 19 Nov 2014 14:32:08 +0000, Kan Liang wrote:
> >> On Tue, 18 Nov 2014 16:36:55 -0500, kan liang wrote:
> >> > +                  if (attr->exclude_user) {
> >> > +                          attr->exclude_user = 0;
> >> > +
> >> > +                          pr_warning("LBR callstack option is only available"
> >> > +                                     " to get user callchain information."
> >> > +                                     " Force exclude_user to 0.\n");
> >> > +                  }
> >>
> >> I'm not sure what's in a higher priority - maybe I missed earlier discussion.
> >> IOW what about this?
> >>
> >>                      if (attr->exclude_user) {
> >>                              pr_warning("LBR callstack option is only available"
> >>                                         " to get user callchain information.\n");
> >
> > I think either is fine. I'd like to add more info "Falling back to framepointers."
> > based on your changes.
> > So the user know what they will get then.
> >
> > What do you think?
>
> Looks good to me.  But I still slightly prefer not to override user
> settings.  But it's not a strong opinion though - I'd like to here from
> others.
>
I don't like when the tool changes the use settings under the hood.
I think perf did that with cycles -> TASK_CLOCK if PMU was not
supported and that was very confusing to me especially with no
warning.
So if LBR Call stack mode is not avail, then inform the user with a warning
or error, don't swap silently.
