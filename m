Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbaCTVNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:13:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51920 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503AbaCTVNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:13:42 -0400
Date: Thu, 20 Mar 2014 17:13:39 -0400 (EDT)
Message-Id: <20140320.171339.838529247165735046.davem@davemloft.net>
To: richardcochran@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ben@decadent.org.uk,
        christian.riesch@omicron.at, stefan.sorensen@spectralink.com
Subject: Re: [PATCH net-next v2 1/9] ptp: introduce programmable pins.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140320204307.GA4931@netboy>
References: <5faff8ea096044a48e4edcc6391844f8d428383f.1394975663.git.richardcochran@gmail.com>
	<20140317.212534.579591104509436501.davem@davemloft.net>
	<20140320204307.GA4931@netboy>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Mar 2014 14:13:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Thu, 20 Mar 2014 21:43:08 +0100

> On Mon, Mar 17, 2014 at 09:25:34PM -0400, David Miller wrote:
>> 
>> This locking seems unnecessarily complex to me.  You should be able to
>> do the stateless sanity checks, take the mutex, then do all of the
>> rest of the operations until the end of the function before
>> dropping the lock.
>> 
>> So just take the lock once over the operations that need it.
> 
> The idea was to avoid holding the mutex when invoking the driver
> callbacks (.verify and .enable). Mostly this is my paranoia that some
> bad driver will call back into the core via ptp_set_pinfunc().

During my review, I checked all the implementations of said methods
and they all universally adjust software state and return.

> But you are right that the result is overly complex. I'll make the
> callers of ptp_set_pinfunc hold the mutex, and so the set path will
> look just like the get path.

Thanks.
