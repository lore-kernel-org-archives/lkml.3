Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3KDWBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:01:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3KDWBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:01:06 -0500
Date: Mon, 4 Nov 2013 14:01:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: karl.kiniger@med.ge.com, jack@suse.cz, linux-kernel@vger.kernel.org,
        t.artem@lycos.com, linux-mm@kvack.org, mgorman@suse.de, tytso@mit.edu,
        fengguang.wu@intel.com, torvalds@linux-foundation.org,
        mpatlasov@parallels.com
Subject: Re: [PATCH] mm: add strictlimit knob
Message-Id: <20131104140104.7936d263258a7a6753eb325e@linux-foundation.org>
In-Reply-To: <20131101142941.1161.40314.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131031142612.GA28003@kipc2.localdomain>
	<20131101142941.1161.40314.stgit@dhcp-10-30-17-2.sw.ru>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Nov 2013 18:31:40 +0400 Maxim Patlasov <MPatlasov@parallels.com> wrote:

> "strictlimit" feature was introduced to enforce per-bdi dirty limits for
> FUSE which sets bdi max_ratio to 1% by default:
> 
> http://www.http.com//article.gmane.org/gmane.linux.kernel.mm/105809
> 
> However the feature can be useful for other relatively slow or untrusted
> BDIs like USB flash drives and DVD+RW. The patch adds a knob to enable the
> feature:
> 
> echo 1 > /sys/class/bdi/X:Y/strictlimit
> 
> Being enabled, the feature enforces bdi max_ratio limit even if global (10%)
> dirty limit is not reached. Of course, the effect is not visible until
> max_ratio is decreased to some reasonable value.

I suggest replacing "max_ratio" here with the much more informative
"/sys/class/bdi/X:Y/max_ratio".

Also, Documentation/ABI/testing/sysfs-class-bdi will need an update
please.

>  mm/backing-dev.c |   35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 

I'm not really sure what to make of the patch.  I assume you tested it
and observed some effect.  Could you please describe the test setup and
the effects in some detail?

