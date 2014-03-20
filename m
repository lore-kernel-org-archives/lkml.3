Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbaCTUnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:43:23 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33597 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759851AbaCTUnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:43:21 -0400
Date: Thu, 20 Mar 2014 21:43:08 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ben@decadent.org.uk,
        christian.riesch@omicron.at, stefan.sorensen@spectralink.com
Subject: Re: [PATCH net-next v2 1/9] ptp: introduce programmable pins.
Message-ID: <20140320204307.GA4931@netboy>
References: <cover.1394975663.git.richardcochran@gmail.com>
 <5faff8ea096044a48e4edcc6391844f8d428383f.1394975663.git.richardcochran@gmail.com>
 <20140317.212534.579591104509436501.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317.212534.579591104509436501.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 09:25:34PM -0400, David Miller wrote:
> 
> This locking seems unnecessarily complex to me.  You should be able to
> do the stateless sanity checks, take the mutex, then do all of the
> rest of the operations until the end of the function before
> dropping the lock.
> 
> So just take the lock once over the operations that need it.

The idea was to avoid holding the mutex when invoking the driver
callbacks (.verify and .enable). Mostly this is my paranoia that some
bad driver will call back into the core via ptp_set_pinfunc().

But you are right that the result is overly complex. I'll make the
callers of ptp_set_pinfunc hold the mutex, and so the set path will
look just like the get path.

Thanks,
Richard
