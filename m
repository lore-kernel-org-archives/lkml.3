Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966316Ab3HHUAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:00:25 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:33902 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966063Ab3HHUAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:00:23 -0400
Message-ID: <1375991950.10300.216.camel@misato.fc.hp.com>
Subject: Re: [PATCH] mm/hotplug: Verify hotplug memory range
From: Toshi Kani <toshi.kani@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, dave@sr71.net,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "vasilis.liaskovitis" <vasilis.liaskovitis@profitbricks.com>
Date: Thu, 08 Aug 2013 13:59:10 -0600
In-Reply-To: <CAHGf_=qPnmpqxeQ1TkXxapRFvdLbLhC53qS3kNATurhoxKd2PQ@mail.gmail.com>
References: <1375980460-28311-1-git-send-email-toshi.kani@hp.com>
	 <CAHGf_=qPnmpqxeQ1TkXxapRFvdLbLhC53qS3kNATurhoxKd2PQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 15:53 -0400, KOSAKI Motohiro wrote:
> On Thu, Aug 8, 2013 at 12:47 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > add_memory() and remove_memory() can only handle a memory range aligned
> > with section.  There are problems when an unaligned range is added and
> > then deleted as follows:
> >
> >  - add_memory() with an unaligned range succeeds, but __add_pages()
> >    called from add_memory() adds a whole section of pages even though
> >    a given memory range is less than the section size.
> >  - remove_memory() to the added unaligned range hits BUG_ON() in
> >    __remove_pages().
> >
> > This patch changes add_memory() and remove_memory() to check if a given
> > memory range is aligned with section at the beginning.  As the result,
> > add_memory() fails with -EINVAL when a given range is unaligned, and
> > does not add such memory range.  This prevents remove_memory() to be
> > called with an unaligned range as well.  Note that remove_memory() has
> > to use BUG_ON() since this function cannot fail.
> >
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> >  mm/memory_hotplug.c |   22 ++++++++++++++++++++++
> 
> memory_hotplug.c is maintained by me and kamezawa-san. Please cc us
> if you have a subsequent patch.

Oh, I see.  Sorry about that.  Yes, I will copy you two from the next
time. 

> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thanks!
-Toshi

