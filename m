Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3CYK2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:28:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab3CYK2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:28:40 -0400
Date: Mon, 25 Mar 2013 10:28:38 +0000
From: Joe Thornber <thornber@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: dm-cache fails to write the cache device in
 writethrough mode
Message-ID: <20130325102837.GB6340@debian>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org
References: <20130322201151.GB5357@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322201151.GB5357@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Fri, Mar 22, 2013 at 01:11:51PM -0700, Darrick J. Wong wrote:
> The new writethrough strategy for dm-cache issues a bio to the origin device,
> remaps the bio to the cache device, and issues the bio to the cache device.
> However, the block layer modifies bi_sector and bi_size, so we need to preserve
> these or else nothing gets written to the cache (bi_size == 0).  This fixes the
> problem where someone writes a block through the cache, but a subsequent reread
> (from the cache) returns old contents.

Thanks for diagnosing this, as you may have gathered none of the
hardware we're testing on does this.  I've pushed a patch to dm-devel
that hopefully will make it's way upstream very quickly.  I used
dm_bio_record/restore, since there are many more fields that
underlying drivers make tweak in the bio.

- Joe
