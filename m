Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaJMP7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:59:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:55064 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbaJMP7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:59:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,711,1406617200"; 
   d="scan'208";a="588100696"
Message-ID: <1413215953.7906.63.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v3] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-msm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Mon, 13 Oct 2014 18:59:13 +0300
In-Reply-To: <1413214637.7906.49.camel@sauron.fi.intel.com>
References: <1412593268-12377-1-git-send-email-tlinder@codeaurora.org>
	 <1413214637.7906.49.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 18:37 +0300, Artem Bityutskiy wrote:
> On Mon, 2014-10-06 at 14:01 +0300, Tanya Brokhman wrote:
> > If there is more then one UBI device mounted, there is no way to
> > distinguish between messages from different UBI devices.
> > Add device number to all ubi layer message types.
> 
> Looks good to me, pushed to the master branch of the linux-ubifs.git
> tree. Later, when the merge window is closed, I'll merge this patch to
> the linux-next branch too.

Tanya,

sorry, I was not careful enough, I merged it and tested against the
Linuses head, it is fine.

But it does not apply the the linux-ubifs.git tree. There are conflicts.

But more importantly, you did not get the 'block.c' right. There we use
the same printing macros, but we do not have 'struct ubi_info' there at
all.

Please, enable the R/O block layer feature and try to compile, it'll
fail.

The block driver is in 'drivers/mtd/ubi', but it is kind of a separate
driver - it does not access the internal UBI data structures.

I guess the solution would be to just use pr_* functions there instead.

CCing Ezequiel.

Please, submit a patch against the 'linux-next' branch of this tree:

git://git.infradead.org/linux-ubifs.git


Artem.

