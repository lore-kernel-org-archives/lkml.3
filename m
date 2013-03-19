Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab3CSRM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:12:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019Ab3CSRMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:12:24 -0400
Date: Tue, 19 Mar 2013 13:12:09 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] [char] random: fix priming of last_data
Message-ID: <20130319171209.GD20163@redhat.com>
References: <1363709889-22344-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363709889-22344-1-git-send-email-jarod@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 12:18:09PM -0400, Jarod Wilson wrote:
> Commit ec8f02da9e added priming of last_data per fips requirements.
> Unfortuantely, it did so in a way that can lead to multiple threads all
> incrementing nbytes, but only one actually doing anything with the extra
> data, which leads to some fun  random corruption and panics.
> 
> The fix is to simply do everything needed to prime last_data in a single
> shot, so there's no window for multiple cpus to increment nbytes -- in
> fact, we won't even increment or decrement nbytes anymore, we'll just
> extract the needed EXTRACT_BYTES one time per pool and then carry on with
                             ^^^^^
		     EXTRACT_SIZE

Error in the description, if anyone actually cares. Oops.

> the normal routine.
> 
> All these changes have been tested across multiple hosts and architectures
> where panics were previously encoutered. The code changes are are strictly
> limited to areas only touched when when booted in fips mode.
> 
> This change should also go into 3.8-stable, to make the myriads of fips
> users on 3.8.x happy.

-- 
Jarod Wilson
jarod@redhat.com

