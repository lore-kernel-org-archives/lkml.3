Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab3HLOuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:50:46 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:20164 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3HLOuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:50:44 -0400
Message-ID: <1376318968.10300.334.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] mm/hotplug: Verify hotplug memory range
From: Toshi Kani <toshi.kani@hp.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, dave@sr71.net,
        isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Date: Mon, 12 Aug 2013 08:49:28 -0600
In-Reply-To: <20130811233722.GA27223@hacker.(null)>
References: <1376162252-26074-1-git-send-email-toshi.kani@hp.com>
	 <20130811233722.GA27223@hacker.(null)>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-12 at 07:37 +0800, Wanpeng Li wrote:
> On Sat, Aug 10, 2013 at 01:17:32PM -0600, Toshi Kani wrote:
> >add_memory() and remove_memory() can only handle a memory range aligned
> >with section.  There are problems when an unaligned range is added and
> >then deleted as follows:
> >
> > - add_memory() with an unaligned range succeeds, but __add_pages()
> >   called from add_memory() adds a whole section of pages even though
> >   a given memory range is less than the section size.
> > - remove_memory() to the added unaligned range hits BUG_ON() in
> >   __remove_pages().
> >
> >This patch changes add_memory() and remove_memory() to check if a given
> >memory range is aligned with section at the beginning.  As the result,
> >add_memory() fails with -EINVAL when a given range is unaligned, and
> >does not add such memory range.  This prevents remove_memory() to be
> >called with an unaligned range as well.  Note that remove_memory() has
> >to use BUG_ON() since this function cannot fail.
> >
> >Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> >Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
> 
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Thanks Wanpeng!
-Toshi

