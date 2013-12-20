Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3LTNmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:42:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49319 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932714Ab3LTNms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:42:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Nigel Cunningham <nigel@nigelcunningham.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH wq/for-3.14 2/2] workqueue: implement @drain for workqueue_set_max_active()
Date: Fri, 20 Dec 2013 14:56:09 +0100
Message-ID: <1811935.VrHgpxyl42@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131220133220.GB4298@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org> <2641617.ixtfWHNgaa@vostro.rjw.lan> <20131220133220.GB4298@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 20, 2013 08:32:20 AM Tejun Heo wrote:
> Hello, Rafael.
> 
> On Fri, Dec 20, 2013 at 02:31:37AM +0100, Rafael J. Wysocki wrote:
> > > If this looks good to you, I'll commit it to wq/for-3.14 and we can at
> > > least start to clean up things.
> > 
> > Yes, it does.
> > 
> > So with that I need to do workqueue_set_max_active(wq, WQ_FROZEN_ACTIVE) during
> > suspend and then workqueue_set_max_active(wq, WQ_DFL_ACTIVE) during resume on
> > my workqueue, right?
> 
> Yeah, you can also do workqueue_set_max_active(wq, 0) during resume to
> restore the default value, which is what's used by alloc_workqueue()
> anyway.

OK

> I'll apply the two patches to wq/for-3.14 once David reviews them or
> if you wanna take them through the pm tree, that's fine too.  I don't
> have anything scheduled for wq for the next merge window.

I have some material queued up, so I can take them once they've been reviewed.

Thanks,
Rafael

