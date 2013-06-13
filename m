Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab3FMCtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:49:07 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:59647 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab3FMCtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:49:05 -0400
Date: Wed, 12 Jun 2013 19:48:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
Message-ID: <20130613024859.GA7432@mtj.dyndns.org>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
 <1371070996-20613-5-git-send-email-tj@kernel.org>
 <51B93038.9010202@huawei.com>
 <20130613023831.GB10979@localhost>
 <CAOS58YPv_uKeTqZSNF=sXTEnLn=LTbsdpBPM5K_ykXoVT-+CpA@mail.gmail.com>
 <20130613024310.GC10979@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613024310.GC10979@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 07:43:10PM -0700, Kent Overstreet wrote:
> list_del() does do poisoning - and list debugging is cheaper to enable
> than full slab debugging.

Ah, right, now we have DEBUG_LIST.  Completely forgot about that.  I
don't think the cost difference matters that much as long as there are
enough people running with slab debugging, but, yeah, with DEBUG_LIST,
leaving list_del() alone would actually be better.  I'll drop that
part.

Thanks.

-- 
tejun
