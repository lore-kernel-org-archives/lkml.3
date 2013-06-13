Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab3FMCih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:38:37 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46565 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252Ab3FMCie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:38:34 -0400
Date: Wed, 12 Jun 2013 19:38:31 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        cl@linux-foundation.org
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
Message-ID: <20130613023831.GB10979@localhost>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
 <1371070996-20613-5-git-send-email-tj@kernel.org>
 <51B93038.9010202@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B93038.9010202@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 10:36:40AM +0800, Li Zefan wrote:
> On 2013/6/13 5:03, Tejun Heo wrote:
> > There's no point in using kmalloc() and list_del() instead of the
> > clearing variants for trivial stuff.  We can live dangerously
> > elsewhere.  Use kzalloc() and list_del_init() instead and drop 0
> > inits.
> > 
> 
> Do you mean we prefer list_del_init() than list_del() in general? Then
> in which cases do we prefer list_del()?

IMO, list_del() is preferred when the object shouldn't be reused (i.e.
it gets taken off a list and then it's freed). list_del_init() could
hide bugs.
