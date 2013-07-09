Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab3GIRND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:13:03 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:58645 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3GIRNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:13:00 -0400
Message-ID: <51DC4497.6060107@openvz.org>
Date: Tue, 09 Jul 2013 21:12:55 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
References: <20130708100046.14417.12932.stgit@zurg> <20130709153907.GA17972@thunk.org>
In-Reply-To: <20130709153907.GA17972@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o wrote:
> Another major problem with this concept is that it lumps all I/O's
> into a single cgroup.  So I/O's from pseudo filesystems (such as
> reading from /sys/kernel/debug/tracing/trace_pipe), networked file
> systems such as NFS, and I/O to various different block devices all
> get counted in a single per-cgroup limit.
>
> This doesn't seem terribly useful to me.  Network resources and block
> resources are quite different, and counting pseudo file systems and
> ram disks makes no sense at all.

Yep, I know it. I've already mentioned about this as first planned improvement:

|* Split bdi into several tiers and account them separately. For example:
|  hdd/ssd/usb/nfs. In complicated containerized environments that might be
|  different kinds of storages with different limits and billing. This is more
|  usefull that independent per-disk accounting and much easier to implement
|  because all per-tier structures are allocated before disk appearance.

Accounting each BDI separately doesn't very useful too, so I've chosen
something in the middle.

>
> Regards,
>
> 					- Ted
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>

