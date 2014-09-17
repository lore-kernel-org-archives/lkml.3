Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaIQInr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:43:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:40970 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbaIQInp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:43:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="387287373"
Message-ID: <1410943421.28850.93.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Fix possible deadlock in erase_worker()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Wed, 17 Sep 2014 11:43:41 +0300
In-Reply-To: <541948E3.3080602@nod.at>
References: <1410853702-11616-1-git-send-email-richard@nod.at>
	 <1410942507.28850.78.camel@sauron.fi.intel.com> <541948E3.3080602@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-17 at 10:40 +0200, Richard Weinberger wrote:
> /*
>  * nested locking. NOTE: rwsems are not allowed to recurse
>  * (which occurs if the same task tries to acquire the same
>  * lock instance multiple times), but multiple locks of the
>  * same lock class might be taken, if the order of the locks
>  * is always the same. This ordering rule can be expressed
>  * to lockdep via the _nested() APIs, but enumerating the
>  * subclasses that are used. (If the nesting relationship is
>  * static then another method for expressing nested locking is
>  * the explicit definition of lock class keys and the use of
>  * lockdep_set_class() at lock initialization time.
>  * See Documentation/lockdep-design.txt for more details.)
>  */
> 
> In this case the same task is taking the same lock multiple times,
> which is not allowed according to rwsem.h.

Yes, this part was missed, thanks.

-- 
Best Regards,
Artem Bityutskiy

