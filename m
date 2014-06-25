Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbaFYLU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:20:27 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:51597 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbaFYLUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:20:25 -0400
X-Yandex-Uniq: 5cede9e7-a0a1-4b16-b42d-5dba72148337
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Wed, 25 Jun 2014 15:20:19 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com,
        rusty@rustcorp.com.au, bp@suse.de
Subject: Re: [PATCH v4 0/4] perf timechart io mode
Message-ID: <20140625112019.GC21788@stfomichev-desktop.yandex.net>
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru>
 <20140624084113.GC31390@krava.redhat.com>
 <20140624091022.GE20225@stfomichev-desktop.yandex.net>
 <20140624165712.GA10114@stfomichev-desktop.yandex.net>
 <53A9B7A4.9050805@gmail.com>
 <20140624185134.GB1148@krava.brq.redhat.com>
 <53A9CB6E.5080104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A9CB6E.5080104@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >maybe we dont need to fail in this case.. seems like it should
> >not be hard to detect, wanr and recover? ;-)
The easiest way is just to bail out and don't try to be smart, that's
what I do now.

Another approach would be to just convert all my consistency
checks to warnings and skip invalid events (and hope it somehow works). I
think it makes sense when for some reason we have perf.data which
is not really consistent but we still want to get something out of it.

> seems to me it should not be happening at all. It seems like the head caught
> the tail and was not properly detected.
So you mean it perf record's fault?
