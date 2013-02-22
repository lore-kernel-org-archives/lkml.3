Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3BVANu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 19:13:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:40283 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577Ab3BVANt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 19:13:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,711,1355126400"; 
   d="scan'208";a="205102007"
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dcache: make Oracle more scalable on large systems
References: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com>
	<20130221233818.GM26694@dastard>
Date: Thu, 21 Feb 2013 16:13:45 -0800
In-Reply-To: <20130221233818.GM26694@dastard> (Dave Chinner's message of "Fri,
	22 Feb 2013 10:38:18 +1100")
Message-ID: <m2bobdxl1i.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Tue, Feb 19, 2013 at 01:50:55PM -0500, Waiman Long wrote:
>> It was found that the Oracle database software issues a lot of call
>> to the seq_path() kernel function which translates a (dentry, mnt)
>> pair to an absolute path. The seq_path() function will eventually
>> take the following two locks:
>
> Nobody should be doing reverse dentry-to-name lookups in a quantity
> sufficient for it to become a performance limiting factor. What is
> the Oracle DB actually using this path for?

Yes calling d_path frequently is usually a bug elsewhere.
Is that through /proc ? 

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
