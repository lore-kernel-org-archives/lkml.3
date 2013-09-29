Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3I2WY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 18:24:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52153 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab3I2WYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 18:24:55 -0400
Date: Sun, 29 Sep 2013 23:24:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfs: Get rid of duplicate file_ops check in
 do_readv_writev()
Message-ID: <20130929222453.GP13318@ZenIV.linux.org.uk>
References: <1380447470-2811-1-git-send-email-namhyung@kernel.org>
 <1380447470-2811-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380447470-2811-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 06:37:50PM +0900, Namhyung Kim wrote:
> The file->f_op check in do_readv_writev() is redundant since all of
> its caller (vfs_readv and vfs_writev) already did the check.  The
> same goes to compat_do_readv_writev().

... and the right fix is to kill all those checks completely.  I have that
done in local queue; will push to #for-next tonight.  file->f_op should
never be NULL, period.
