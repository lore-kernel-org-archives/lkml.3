Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaDHPjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:39:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:12242 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924AbaDHPjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:39:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,818,1389772800"; 
   d="scan'208";a="516921031"
Message-ID: <1396968207.30750.17.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] ubi: avoid workqueue format string leak
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Kees Cook <keescook@chromium.org>, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 08 Apr 2014 17:43:27 +0300
In-Reply-To: <20140408135729.GC2429@arch.cereza>
References: <20140408044407.GA13141@www.outflux.net>
	 <20140408135729.GC2429@arch.cereza>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 10:57 -0300, Ezequiel Garcia wrote:
> Hello Kees,
> 
> Thanks for the patch.
> 
> On Apr 07, Kees Cook wrote:
> > When building the name for the workqueue thread, make sure a format
> > string cannot leak in from the disk name.
> > 
> 
> Could you enlighten me and explain why you want to avoid the name leak?
> Is it a security concern?
> 
> I'd like to understad this better, so I can avoid making such mistakes
> in the future.

Well, the basics seem to be simple, attacker makes sure gd->disk_name
contains a bunch of "%s" and other placeholders, and this leads
"workqueue_alloc()" to read kernel memory and form the workqueue name.

I did not think it through further, though, but that was enough for me
to apply the patch right away. But yeah, curios parts are:

1. How attacker could end up with a crafted "gd->disk_name"
2. How attacker gets the workqueue name then, I guess there is a sysfs
file or something, but I do not know off the top of my head.

Yeah, I am interested to get educated on this a too.

-- 
Best Regards,
Artem Bityutskiy

