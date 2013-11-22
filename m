Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab3KVUXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:23:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab3KVUXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:23:02 -0500
Date: Fri, 22 Nov 2013 21:24:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, keescook@chromium.org,
        mhocko@suse.cz, snanda@chromium.org, dserrg@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] check_unsafe_exec: use while_each_thread() rather
	than next_thread()
Message-ID: <20131122202412.GA19563@redhat.com>
References: <20131122175439.GA31446@redhat.com> <528FB3B4.3030303@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528FB3B4.3030303@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22, KOSAKI Motohiro wrote:
>
> (11/22/2013 12:54 PM), Oleg Nesterov wrote:
> > next_thread() should be avoided, change check_unsafe_exec()
> > to use while_each_thread(). This also saves 32 bytes.
>
> Just curious.
> Why it should be avoided? Just for cleaner code?

Nobody except signal->curr_target actually need next_thread-like
code, and

> Or is there
> serious issue?

We need to change (fix) this interface. This particular code is
fine, p == current. But in general the code like this can loop
forever if p exits and next_thread(t) can't reach the unhashed
thread.

Oleg.

