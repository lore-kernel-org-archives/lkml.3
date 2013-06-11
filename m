Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab3FKUKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:10:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab3FKUKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:10:12 -0400
Date: Tue, 11 Jun 2013 22:06:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tomas Janousek <tjanouse@redhat.com>,
        Tomas Smetana <tsmetana@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] de_thread() should update ->real_start_time
Message-ID: <20130611200600.GA15168@redhat.com>
References: <20130610183300.GA14379@redhat.com> <CANcMJZCr+Jr+J495MHX+1wnet_UtM6hSR+mgAGMma_YvLaxn4A@mail.gmail.com> <20130611171300.GA7920@redhat.com> <51B7690C.8090805@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B7690C.8090805@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11, John Stultz wrote:
>
> On 06/11/2013 10:13 AM, Oleg Nesterov wrote:
>
>> But perhaps this is fine and even more correct?
>
> So I think it probably *makes more sense* to include suspend_time in the
> elapsed runtime value being exported via bacct_add_tsk() and
> do_acct_process(), but I unfortunately worry now any such change would
> risk breaking userland expectations.
>
> The *actual* risk may be quite minor, so this could be one of those:
> "Let the tree fall and if no one is there to hear it, fine" interface
> breaks, but I'm not sure I'm eager enough to be the one proposing it. :)

Yes, same thoughts here ;)

Still it is ugly imho to keep task->start_time just for taskstats,
and _I think_ nobody really cares. Perhaps I'll try to send the patch
later...

And look. It seems that ->ac_btime (Process Creation Time) in
bacct_add_tsk() is obviously wrong anyway? So perhaps we can fix
this and in this case we can also change the meaning of start_time.

Oleg.

