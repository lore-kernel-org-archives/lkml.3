Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab3D2WIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:08:41 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51121 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944Ab3D2WIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:08:35 -0400
Date: Mon, 29 Apr 2013 15:08:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@android.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Li Zefan <lizefan@huawei.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 02/10] freezer: skip waking up tasks with PF_FREEZER_SKIP
 set
Message-ID: <20130429220831.GC2395@htj.dyndns.org>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
 <1367271946-7239-3-git-send-email-ccross@android.com>
 <20130429215157.GA2395@htj.dyndns.org>
 <20130429215745.GB2395@htj.dyndns.org>
 <CAMbhsRQHkm=XTYtummEZq1h4sa-tRGwLpk8Uyhpj9D3+jQF3dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRQHkm=XTYtummEZq1h4sa-tRGwLpk8Uyhpj9D3+jQF3dg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Apr 29, 2013 at 03:02:19PM -0700, Colin Cross wrote:
> See the first patch in the series (which isn't available in the
> archive yet, so I can't link to it).  The short version is that

It didn't arrive in my lkml folder either.  Maybe vger is taking some
time distributing emails.

> Android goes through suspend/resume very often (every few seconds when
> on a busy wifi network with the screen off), and a significant portion
> of the energy used to go in and out of suspend is spent in the
> freezer.  This patch series takes the most common userspace sleep
> points and converts them to PF_FREEZER_SKIP, which reduces the number
> of context switches for every suspend or resume event on a
> freshly-booted Android device from 1000 to 25, and reduces the time

Ah, okay, so you're spreading PF_FREEZER_SKIP.  When you post patches
which touch the freezer can you please cc me and Oleg Nesterov
<oleg@redhat.com> (I'll ping him this time)?  Freezer has been very
subtly broken in various ways and many kthread users are still broken,
so let's tread carefully.

> spent freezing by a factor of 5.  It will have a similar effect on a
> non-Android system, although those generally don't care about
> suspend/resume optimization.

Yeah, if it's something which makes actual difference rather than
"this seems to be a good idea" thing, sure, let's find a way.

Thanks.

-- 
tejun
