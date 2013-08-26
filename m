Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3HZOWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:22:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3HZOWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:22:30 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=dRXjL8aGtIIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vCXdsJORpdIA:10 a=3nbZYyFuAAAA:8 a=fVj-U3WoxfrRRX2cS3kA:9 a=CjuIK1q_8ugA:10 a=EvKJbDF4Ut8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 26 Aug 2013 10:22:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 00/11] trace-cmd: Support the feature recording
 trace data of guests on the host
Message-ID: <20130826102229.6e0129fe@gandalf.local.home>
In-Reply-To: <521AB37E.4050800@hitachi.com>
References: <20130819094620.26597.79499.stgit@yunodevel>
	<20130820120006.1a4118c5@gandalf.local.home>
	<521AB37E.4050800@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 10:46:38 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> > The --date option is used because the two machines are not in sync with
> > the trace time stamp. What the date option does, is to sync the
> > timestamp up with the gettimeofday and the output reports that. This
> > allows the two boxes to report information that is relatively close to
> > how the two interacted.
> 
> Oh, I didn't know the --date option.
> As you mentioned, we can merge trace data in chronological order by
> using --date option if the times of those machines are synchronized by
> NTP.
> 
> > If the guest and the host have the same clock, then the --date option
> > is not needed and the two should be able to be merged normally.
> 
> No, we can not assure that the guest and the host have the same clock
> even if it is running on the same physical machine, because both kernel
> doesn't share it, there is some difference between them. So, we still
> need time synchronizing guest-host by NTP and --date option.
> 
> However, there are cases that times of those machines cannot be
> synchronized. For example, although multiple users can run guests on
> virtualization environments (e.g. multi-tenant cloud hosting), there
> are no guarantee that they use the same NTP server. Moreover, even if
> the times are synchronized, trace data cannot exactly be merged because
> the NTP-synchronized time granularity may not be enough fine for
> sorting guest-host switching events.

Right, unless there's some other means no synchronize between boxes,
this is currently the best we have.

> 
> > Also, I haven't released it yet (will soon), but trace-cmd handles
> > multiple buffers too. That is, with the multiple buffers that ftrace
> > has, it will create and read from them as well as report them.
> 
> Is it commit ID d56f30679f9811a91ed471c8e081cc7ffbed1e62?
> We can download the feature from your git repository.

Yep.

-- Steve
