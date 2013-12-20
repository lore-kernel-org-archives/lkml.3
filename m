Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab3LTNc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:32:28 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48523 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab3LTNcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:32:23 -0500
Date: Fri, 20 Dec 2013 08:32:20 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Nigel Cunningham <nigel@nigelcunningham.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH wq/for-3.14 2/2] workqueue: implement @drain for
 workqueue_set_max_active()
Message-ID: <20131220133220.GB4298@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <1735137.dNmBz0IqxU@vostro.rjw.lan>
 <20131219233720.GE22725@htj.dyndns.org>
 <2641617.ixtfWHNgaa@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2641617.ixtfWHNgaa@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Fri, Dec 20, 2013 at 02:31:37AM +0100, Rafael J. Wysocki wrote:
> > If this looks good to you, I'll commit it to wq/for-3.14 and we can at
> > least start to clean up things.
> 
> Yes, it does.
> 
> So with that I need to do workqueue_set_max_active(wq, WQ_FROZEN_ACTIVE) during
> suspend and then workqueue_set_max_active(wq, WQ_DFL_ACTIVE) during resume on
> my workqueue, right?

Yeah, you can also do workqueue_set_max_active(wq, 0) during resume to
restore the default value, which is what's used by alloc_workqueue()
anyway.

I'll apply the two patches to wq/for-3.14 once David reviews them or
if you wanna take them through the pm tree, that's fine too.  I don't
have anything scheduled for wq for the next merge window.

Thanks.

-- 
tejun
