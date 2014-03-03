Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaCCWny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:43:54 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:49333 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbaCCWnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:43:52 -0500
Date: Mon, 3 Mar 2014 17:43:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biederman <ebiederm@xmission.com>
Subject: Re: Bug in fs/kernfs/dir.c comment or code?
Message-ID: <20140303224345.GD26523@mtj.dyndns.org>
References: <20140302201656.GA5659@netboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140302201656.GA5659@netboy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Greg and Eric)

On Sun, Mar 02, 2014 at 09:16:58PM +0100, Richard Cochran wrote:
> I stumbled across this in fs/kernfs/dir.c:39.
> 
> 	/* Reserve hash numbers 0, 1 and INT_MAX for magic directory entries */
> 	if (hash < 1)
> 		hash += 2;
> 	if (hash >= INT_MAX)
> 		hash = INT_MAX - 1;
> 
> Shouldn't that be (hash < 2), or is 1 not reserved?

Looks like the code is wrong and the condition should be hash < 2.
Difficult to trigger but an actual bug.  The fix should probably be
propagated to sysfs through -stable.  Can you write up a patch?

Thanks.

-- 
tejun
