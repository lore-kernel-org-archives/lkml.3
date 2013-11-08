Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab3KHFSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 00:18:07 -0500
Received: from imap.thunk.org ([74.207.234.97]:55579 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab3KHFSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 00:18:02 -0500
Date: Fri, 8 Nov 2013 00:17:57 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: David Turner <novalis@novalis.org>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH v3] ext4: Fix reading of extended tv_sec (bug 23732)
Message-ID: <20131108051757.GE11668@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	David Turner <novalis@novalis.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
References: <1383808590.23882.13.camel@chiang>
 <20131107160341.GA3850@quack.suse.cz>
 <1383864864.23882.33.camel@chiang>
 <20131107231445.GG2054@quack.suse.cz>
 <1383866807.23882.41.camel@chiang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383866807.23882.41.camel@chiang>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 06:26:47PM -0500, David Turner wrote:
> In ext4, the bottom two bits of {a,c,m}time_extra are used to extend
> the {a,c,m}time fields, deferring the year 2038 problem to the year
> 2446.  The representation (which this patch does not alter) is a bit
> hackish, in that the most-significant bit is no longer (alone)
> sufficient to indicate the sign.  That's because we're representing an
> asymmetric range, with seven times as many positive values as
> negative.
> 
> When decoding these extended fields, for times whose bottom 32 bits
> would represent a negative number, sign extension causes the 64-bit
> extended timestamp to be negative as well, which is not what's
> intended.  This patch corrects that issue, so that the only negative
> {a,c,m}times are those between 1901 and 1970 (as per 32-bit signed
> timestamps).
> 
> Signed-off-by: David Turner <novalis@novalis.org>
> Reported-by: Mark Harris <mh8928@yahoo.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=23732
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
