Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967421Ab3HIDD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 23:03:58 -0400
Received: from imap.thunk.org ([74.207.234.97]:41323 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967185Ab3HIDD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 23:03:57 -0400
Date: Thu, 8 Aug 2013 23:03:50 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Piotr Sarna <p.sarna@partner.samsung.com>
Cc: adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, b.zolnierkie@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] ext4: improve mount/remount error handling
Message-ID: <20130809030350.GB1186@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Piotr Sarna <p.sarna@partner.samsung.com>, adilger.kernel@dilger.ca,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	b.zolnierkie@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
References: <1375445027-25024-1-git-send-email-p.sarna@partner.samsung.com>
 <1375445027-25024-2-git-send-email-p.sarna@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375445027-25024-2-git-send-email-p.sarna@partner.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 02:03:47PM +0200, Piotr Sarna wrote:
> Commit 5688978 ("ext4: improve handling of conflicting mount options")
> introduced incorrect messages shown while choosing wrong mount options.
> 
> Firstly, both cases of incorrect mount options, "data=journal,delalloc"
> and "data=journal,dioread_nolock" result in the same error message.
> 
> Secondly, the problem above isn't solved for remount option: the mismatched
> parameter is simply ignored. Moreover, ext4_msg states that remount
> with options "data=journal,delalloc" succeeded, which is not true.
> 
> To fix it up, I added a simple check after parse_options() call to ensure
> that data=journal and delalloc/dioread_nolock parameters are not present
> at the same time.
> 
> Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
> Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Applied, thanks.

						- Ted
