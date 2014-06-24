Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaFXSvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:51:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbaFXSvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:51:51 -0400
Date: Tue, 24 Jun 2014 20:51:34 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
        artagnon@gmail.com, rusty@rustcorp.com.au, bp@suse.de
Subject: Re: [PATCH v4 0/4] perf timechart io mode
Message-ID: <20140624185134.GB1148@krava.brq.redhat.com>
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru>
 <20140624084113.GC31390@krava.redhat.com>
 <20140624091022.GE20225@stfomichev-desktop.yandex.net>
 <20140624165712.GA10114@stfomichev-desktop.yandex.net>
 <53A9B7A4.9050805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A9B7A4.9050805@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 11:38:44AM -0600, David Ahern wrote:
> On 6/24/14, 10:57 AM, Stanislav Fomichev wrote:
> >On Tue, Jun 24, 2014 at 01:10:22PM +0400, Stanislav Fomichev wrote:
> >>>hum, got this when trying:
> >>>
> >>>[jolsa@krava perf]$ sudo ./perf timechart record -I
> >>>^C[ perf record: Woken up 2 times to write data ]
> >>>[ perf record: Captured and wrote 1.071 MB perf.data (~46806 samples) ]
> >>>[jolsa@krava perf]$ ./perf timechart
> >>>Invalid previous event (non-zero)!
> >>>0x113f80 [0x8]: failed to process type: 68
> 
> I see this kind of message a lot, but typically in high event use cases
> (e.g., 100+MB files in a run of a few seconds). I usually increase the map
> size (-m 4096) and/or bump the priority of perf (-r1) and re-run the test.

maybe we dont need to fail in this case.. seems like it should
not be hard to detect, wanr and recover? ;-)

jirka
