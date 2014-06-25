Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbaFYOi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:38:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886AbaFYOi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:38:56 -0400
Date: Wed, 25 Jun 2014 16:38:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
        artagnon@gmail.com, rusty@rustcorp.com.au, bp@suse.de
Subject: Re: [PATCH v4 0/4] perf timechart io mode
Message-ID: <20140625143837.GD1153@krava.brq.redhat.com>
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru>
 <20140624084113.GC31390@krava.redhat.com>
 <20140624091022.GE20225@stfomichev-desktop.yandex.net>
 <20140624165712.GA10114@stfomichev-desktop.yandex.net>
 <53A9B7A4.9050805@gmail.com>
 <20140624185134.GB1148@krava.brq.redhat.com>
 <53A9CB6E.5080104@gmail.com>
 <20140625112019.GC21788@stfomichev-desktop.yandex.net>
 <53AAD62D.3030105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AAD62D.3030105@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 08:01:17AM -0600, David Ahern wrote:
> On 6/25/14, 5:20 AM, Stanislav Fomichev wrote:
> >>>maybe we dont need to fail in this case.. seems like it should
> >>>not be hard to detect, wanr and recover? ;-)
> >The easiest way is just to bail out and don't try to be smart, that's
> >what I do now.
> >
> >Another approach would be to just convert all my consistency
> >checks to warnings and skip invalid events (and hope it somehow works). I
> >think it makes sense when for some reason we have perf.data which
> >is not really consistent but we still want to get something out of it.
> 
> If the event type does not make sense how can you trust any other field --
> like event size?
> 
> >
> >>seems to me it should not be happening at all. It seems like the head caught
> >>the tail and was not properly detected.
> >So you mean it perf record's fault?
> >
> 
> In my cases I am running perf-record. At the end of the session it walks the
> events and in too many cases I see the message:
> 
>  0x113f80 [0x8]: failed to process type: 68
> 

hum.. 68 is PERF_RECORD_FINISHED_ROUND, so there was something wrong
during the queue flush.. thus processing all the queue events and
failing only if either the parsing or delivery fails

jirka
