Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbaKUPqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:46:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56665 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbaKUPqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:46:19 -0500
Date: Fri, 21 Nov 2014 16:46:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Daniel Dressler <danieru.dressler@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: qgroup: add BUILD_BUG to report pointer cast
 breakage
Message-ID: <20141121154617.GA8568@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
	Daniel Dressler <danieru.dressler@gmail.com>,
	Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
References: <danieru.dressler@gmail.com>
 <1415807679-3824-1-git-send-email-danieru.dressler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415807679-3824-1-git-send-email-danieru.dressler@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 12:54:39AM +0900, Daniel Dressler wrote:
> Our ulist data structure stores at max 64bit
> values. qgroup has used this structure to store
> pointers. In the future when we upgrade to 128bit
> this casting of pointers to uint64_t will break.

What are we going to upgrade to 128 bits?

> This patch adds a BUILD_BUG ensuring that this
> code will not be left untouched in the upgrade.
> 
> It also marks this issue on the TODO list so it
> may be addressed before such an upgrade.
> 
> +	(BUILD_BUG_ON_ZERO(sizeof(uintptr_t) > sizeof(u64)) + \

So it's pointers, this is similar to the 32bit -> 64bit transition, a
change that will affect everything, one BUILD_BUG on does not make any
difference.
