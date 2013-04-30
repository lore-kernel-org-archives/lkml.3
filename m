Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab3D3RS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:18:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933549Ab3D3RSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:18:21 -0400
Date: Tue, 30 Apr 2013 19:15:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        containers@redhat.com
Subject: Re: [PATCH 02/10] freezer: skip waking up tasks with
	PF_FREEZER_SKIP set
Message-ID: <20130430171501.GB28944@redhat.com>
References: <1367271946-7239-1-git-send-email-ccross@android.com> <1367271946-7239-3-git-send-email-ccross@android.com> <20130430171059.GA28944@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430171059.GA28944@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Oleg Nesterov wrote:
>
> On 04/29, Colin Cross wrote:
> >
> > @@ -46,10 +46,10 @@ static int try_to_freeze_tasks(bool user_only)
> >  		todo = 0;
> >  		read_lock(&tasklist_lock);
> >  		do_each_thread(g, p) {
> > -			if (p == current || !freeze_task(p))
> > +			if (p == current || freezer_should_skip(p))
> >  				continue;
> >
> > -			if (!freezer_should_skip(p))
> > +			if (freeze_task(p))
> >  				todo++;
>
> What if we race with freezer_count() ?
>
> try_to_freeze_tasks() can wrongly succeed leaving the running task
> unfrozen, no?

Ah, no, sorry for noise.

Oleg.

