Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbbAYWQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 17:16:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38033 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbAYWQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 17:16:44 -0500
Date: Sun, 25 Jan 2015 22:16:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Detect API misuse of i_op->lookup
Message-ID: <20150125221643.GK29656@ZenIV.linux.org.uk>
References: <1422223060-8561-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422223060-8561-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 10:57:40PM +0100, Richard Weinberger wrote:
> Hunting down a refcount issue in an out-of-tree filesystem uncovered
> that its lookup function directly returned the dentry which was passed to it.
> Add a BUG_ON() to detect such misuse in future.

In principle, it's not a bug.  You *must* grab a reference to dentry before
returning it, but you can very well decide to return the one you've got -
any place where have ->lookup() return NULL has every right to become
return dget(dentry).
