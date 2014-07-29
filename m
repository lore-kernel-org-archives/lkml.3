Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaG2TPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:15:35 -0400
Received: from tex.lwn.net ([70.33.254.29]:38735 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaG2TPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:15:33 -0400
X-Greylist: delayed 1042 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2014 15:15:33 EDT
Date: Tue, 29 Jul 2014 14:58:08 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Abhi Das <adas@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Subject: Re: [RFC PATCH 5/5] gfs2: Add xreaddir file operation and
 supporting functions
Message-ID: <20140729145808.79bec165@lwn.net>
In-Reply-To: <1406309888-10749-6-git-send-email-adas@redhat.com>
References: <1406309888-10749-1-git-send-email-adas@redhat.com>
	<1406309888-10749-6-git-send-email-adas@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014 12:38:08 -0500
Abhi Das <adas@redhat.com> wrote:

> This patch adds support in GFS2 for the xgetdents syscall by
> implementing the xreaddir file operation.

So I was trying to make sense of this, and ran into one little thing that
jumped out at me:

> +static int gfs2_xrdir_to_user_vars(struct gfs2_xrdir_ctx *xc,
> +				   struct gfs2_xdirent *x,
> +				   struct gfs2_xdirent *x_vb_p,
> +				   struct linux_xdirent __user *lxd,
> +				   size_t count, size_t *bytes)

Now, I'll readily admit that I could be overly confused by this function.
When the variables are named "x", "xx", "xc", "x_vb_p", "xblob", and "lxd",
it all starts to run together.  But still...

> +	if ((xc->xc_xattr_mask & XSTAT_XATTR_ALL) &&
> +		lxd->xd_blob.xb_xattr_count) {

How can that be right?  lxd is __user, it doesn't seem right to be
dereferencing it directly...?

Thanks,

jon
