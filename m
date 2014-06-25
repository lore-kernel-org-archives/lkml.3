Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbaFYOBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:01:21 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:36497 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888AbaFYOBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:01:20 -0400
Message-ID: <53AAD62D.3030105@gmail.com>
Date: Wed, 25 Jun 2014 08:01:17 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
CC: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com,
        rusty@rustcorp.com.au, bp@suse.de
Subject: Re: [PATCH v4 0/4] perf timechart io mode
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru> <20140624084113.GC31390@krava.redhat.com> <20140624091022.GE20225@stfomichev-desktop.yandex.net> <20140624165712.GA10114@stfomichev-desktop.yandex.net> <53A9B7A4.9050805@gmail.com> <20140624185134.GB1148@krava.brq.redhat.com> <53A9CB6E.5080104@gmail.com> <20140625112019.GC21788@stfomichev-desktop.yandex.net>
In-Reply-To: <20140625112019.GC21788@stfomichev-desktop.yandex.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/14, 5:20 AM, Stanislav Fomichev wrote:
>>> maybe we dont need to fail in this case.. seems like it should
>>> not be hard to detect, wanr and recover? ;-)
> The easiest way is just to bail out and don't try to be smart, that's
> what I do now.
>
> Another approach would be to just convert all my consistency
> checks to warnings and skip invalid events (and hope it somehow works). I
> think it makes sense when for some reason we have perf.data which
> is not really consistent but we still want to get something out of it.

If the event type does not make sense how can you trust any other field 
-- like event size?

>
>> seems to me it should not be happening at all. It seems like the head caught
>> the tail and was not properly detected.
> So you mean it perf record's fault?
>

In my cases I am running perf-record. At the end of the session it walks 
the events and in too many cases I see the message:

  0x113f80 [0x8]: failed to process type: 68

So, yes I think something is happening during the record such as the 
writer passing the reader and corrupting the buffers.

David
