Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3JCOlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:41:14 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:43762 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3JCOlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:41:12 -0400
Date: Thu, 3 Oct 2013 16:41:09 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Khalid Aziz <khalid.aziz@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ 00/13] 3.0.99-stable review
Message-ID: <1380810793@msgid.manchmal.in-ulm.de>
References: <20131003040400.753642257@linuxfoundation.org>
 <524D0663.209@roeck-us.net>
 <1380801873@msgid.manchmal.in-ulm.de>
 <524D72A7.8030200@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D72A7.8030200@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Khalid Aziz wrote...

> Thanks for tracking this down. I had not tried a configuration with
> CONFIG_HUGETLB_PAGE not set. In my config, I was getting many
> multiple definition errors for bunch of other defines from
> linux/hugetlb.h. I will look at my config again but chances are I
> had something else screwed up in my build since you did not see
> those errors. Did you compile with CONFIG_HUGETLB_PAGE set after
> including linux/hugetlb.h? If you did, including linux/hugetlb.h
> instead of importing just the definition of PageHuge in mm/swap.c
> would be the right thing to do.

Yes, one of my configurations has CONFIG_HUGETLB_PAGE, also
CONFIG_NUMA=y, and the kernel built. Could not test it, though.

There still might be other configuration settings that caused the
error messages you've seen. Manually picking both PageHuge definitions
from linux/hugetlb.h should be a safe alternative then, but that's
ugly.

    Christoph
