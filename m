Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaDUQbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:31:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47145 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaDUQa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:30:59 -0400
Date: Mon, 21 Apr 2014 17:30:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [RFC 2/2] fs,proc: Respect FMODE_WRITE when opening
 /proc/pid/fd/N
Message-ID: <20140421163058.GS18016@ZenIV.linux.org.uk>
References: <cover.1398097304.git.luto@amacapital.net>
 <430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 09:22:48AM -0700, Andy Lutomirski wrote:

> +static int proc_may_follow(struct nameidata *nd, struct file *f)
> +{
> +	if (!nd)
> +		return 0;  /* This is readlink, */
> +
> +	if ((nd->flags & LOOKUP_WRITE) && !(f->f_mode & FMODE_WRITE))
> +		return -EACCES;
> +
> +	return 0;
> +}

And this is just plain wrong.  WTF are you making the traversal of symlink
in the middle of pathname dependent on the open flags?

NAK.
