Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbaJNPIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 11:08:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:62150 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbaJNPIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 11:08:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,717,1406617200"; 
   d="scan'208";a="614299326"
Message-ID: <1413299231.7906.101.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v4] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: Tanya Brokhman <tlinder@codeaurora.org>,
        ezequiel.garcia@free-electrons.com, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 14 Oct 2014 18:07:11 +0300
In-Reply-To: <1413297205.3269.11.camel@joe-AO725>
References: <1413296037-22346-1-git-send-email-tlinder@codeaurora.org>
	 <543D304C.5000607@codeaurora.org> <1413297205.3269.11.camel@joe-AO725>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-14 at 07:33 -0700, Joe Perches wrote:
> If you are going to change all the ubi_<level> calls,
> can you also please add a terminating newline to all
> the uses for consistency with all the other
> pr_<level>/dev_<level>/<etc>_<level> calls?

I get the consistency argument.

On the other hand, this is about printing a single line. It is gets
prefixed (with "UBI: ") automatically, why wouldn't we append the
newline character automatically too?

In the generic functions this is for flexibility: rarely, people to want
to print a multi-line message with those. The first line will be
prefixed, the following line won't be prefixed.

We do not need that flexibility. And I think that adding hundreds of
'\n's just for the sake of consistency to be not very attractive option.

IOW, I do not support this suggestion.

> > >   /* UBI error messages */
> > > -#define ubi_err(fmt, ...) pr_err("UBI error: %s: " fmt "\n",      \
> > > -				 __func__, ##__VA_ARGS__)
> > > +#define ubi_err(ubi, fmt, ...) pr_err("UBI-%d error: %s: " fmt "\n",      \
> > > +				 ubi->ubi_num, __func__, ##__VA_ARGS__)
> 
> Converting these macros to functions using "%pV"
> will save quite a bit of text space by removing
> a lot of "UBI-%d <foo>: " duplication.

These were added before '%pV' existed, I think. I never used this printk
extension, but if it results in a more concise code, sounds like a good
idea. But I'd do this separately.

> Using ubi_notice instead of ubi_msg would be a
> lot more standard too.

Yes, this could be an OK separate nicification, I think, if someone is
willing to do this work. I would not put this item to my TODO list,
since this is a lot of changes for with little gain. But I would accept
such a patch, sure.

Thanks!

--
Artem.

