Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab3DUT41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 15:56:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43279 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab3DUT4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 15:56:24 -0400
Date: Sun, 21 Apr 2013 15:55:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-mm@kvack.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        mgorman@suse.de
Subject: Re: [PATCH 3/3] ext4: mark metadata blocks using bh flags
Message-ID: <20130421195534.GA13543@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jiri Slaby <jslaby@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-mm@kvack.org,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	mgorman@suse.de
References: <20130421000522.GA5054@thunk.org>
 <1366502828-7793-1-git-send-email-tytso@mit.edu>
 <1366502828-7793-3-git-send-email-tytso@mit.edu>
 <5173828A.2030809@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5173828A.2030809@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 08:09:14AM +0200, Jiri Slaby wrote:
> On 04/21/2013 02:07 AM, Theodore Ts'o wrote:
> > This allows metadata writebacks which are issued via block device
> > writeback to be sent with the current write request flags.
> 
> Hi, where do these come from?
> fs/ext4/ext4_jbd2.c: In function ‘__ext4_handle_dirty_metadata’:
> fs/ext4/ext4_jbd2.c:218:2: error: implicit declaration of function
> ‘mark_buffer_meta’ [-Werror=implicit-function-declaration]
> fs/ext4/ext4_jbd2.c:219:2: error: implicit declaration of function
> ‘mark_buffer_prio’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors

They are defined by "[PATCH 2/3] buffer: add BH_Prio and BH_Meta flags" here:

+BUFFER_FNS(Meta, meta)
+BUFFER_FNS(Prio, prio)

When you tried applying this patch, did you try applying all three
patches in the patch series?

						- Ted
