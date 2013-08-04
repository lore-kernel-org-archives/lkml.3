Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3HDBtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 21:49:12 -0400
Received: from imap.thunk.org ([74.207.234.97]:39071 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab3HDBtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 21:49:11 -0400
Date: Sat, 3 Aug 2013 21:36:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Piotr Sarna <p.sarna@partner.samsung.com>
Cc: adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, b.zolnierkie@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] ext4: fix handling of nodelalloc parameter
Message-ID: <20130804013658.GD19781@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Piotr Sarna <p.sarna@partner.samsung.com>, adilger.kernel@dilger.ca,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	b.zolnierkie@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
References: <1375445027-25024-1-git-send-email-p.sarna@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375445027-25024-1-git-send-email-p.sarna@partner.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 02:03:46PM +0200, Piotr Sarna wrote:
> Commit 26092bf ("ext4: use a table-driven handler for mount options")
> introduced buggy handling of nodelalloc parameter in mount command.
> 
> After explicitly using delalloc or nodelalloc parameter in mount command,
> MOPT_EXPLICIT flag is set. After that, a test ensures that "data=journal"
> and "delalloc" parameters are not simultaneously activated.
> Unluckily, the mentioned test reports a bug in both situations:
> - "data=journal,delalloc"
> - "data=journal,nodelalloc"
> whereas the second one is perfectly legal and acceptable.
> 
> A simple solution to this problem is in setting EXPLICIT_DELALLOC flag
> properly. This patch ensures that EXPLICIT_DELALLOC flag is set only
> if "delalloc" parameter was used, and not set in case of "nodelalloc".

Thanks for this bug report and patch.  There is an even simpler way of
fixing this doesn't involve adding an additional check in the code,
though.  Just make the following change the table entry:

     {Opt_nodelalloc, EXT4_MOUNT_DELALLOC,
-      MOPT_EXT4_ONLY | MOPT_CLEAR | MOPT_EXPLICIT},
+      MOPT_EXT4_ONLY | MOPT_CLEAR},

I'll send out a patch which does this...

					- Ted
