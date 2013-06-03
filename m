Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab3FCPk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:40:56 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54438 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694Ab3FCPkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:40:53 -0400
Date: Mon, 3 Jun 2013 11:40:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ext4: add sanity checks in __ext4_check_dir_entry
Message-ID: <20130603154048.GC20009@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ruslan Bilovol <ruslan.bilovol@ti.com>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
 <1370253616-8173-3-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370253616-8173-3-git-send-email-ruslan.bilovol@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 01:00:16PM +0300, Ruslan Bilovol wrote:
> Added checks for NULL before dereferencing some pointers
> 
> +	if (!de || !bh || !dir)
> +		return 1;

Do you know which one of these pointers was NULL?

I want't make sure we're fixing the root issue as opposed to papering
over it.  I'm not seeing how any of these pointers could have been
NULL (at least in my upstream kernel), and while I believe that this
helped for your kernel, I want to make sure we understand exactly what
was going on.

Thanks,

					- Ted
