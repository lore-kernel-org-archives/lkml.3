Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab3FMCnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:43:15 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44531 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab3FMCnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:43:14 -0400
Date: Wed, 12 Jun 2013 19:43:10 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
Message-ID: <20130613024310.GC10979@localhost>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
 <1371070996-20613-5-git-send-email-tj@kernel.org>
 <51B93038.9010202@huawei.com>
 <20130613023831.GB10979@localhost>
 <CAOS58YPv_uKeTqZSNF=sXTEnLn=LTbsdpBPM5K_ykXoVT-+CpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YPv_uKeTqZSNF=sXTEnLn=LTbsdpBPM5K_ykXoVT-+CpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 07:41:15PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jun 12, 2013 at 7:38 PM, Kent Overstreet <koverstreet@google.com> wrote:
> > IMO, list_del() is preferred when the object shouldn't be reused (i.e.
> > it gets taken off a list and then it's freed). list_del_init() could
> > hide bugs.
> 
> Nah... use-after-frees are detected much more reliably by poisoning
> anyway. Using list_del() instead of list_del_init() to hunt down
> use-after-free isn't a good idea because you're likely to corrupt the
> memory of unrelated area. I really don't see much point in using
> list_del().

list_del() does do poisoning - and list debugging is cheaper to enable
than full slab debugging.
