Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaA2PSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:18:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47851 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaA2PSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:18:14 -0500
Date: Wed, 29 Jan 2014 15:18:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Alcock <nick.alcock@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: respect FMODE_UNSIGNED_OFFSET in
 p(read|write)[v]*().
Message-ID: <20140129151812.GJ10323@ZenIV.linux.org.uk>
References: <87ppnbf1b3.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppnbf1b3.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 11:57:20AM +0000, Nick Alcock wrote:
>  	ssize_t ret = -EBADF;
>  
> -	if (pos < 0)
> +	f = fdget(fd);
> +	if ((pos < 0) && (!f.file || !unsigned_offsets(f.file))) {
> +		fdput(f);
>  		return -EINVAL;
> +	}

... and now pread(-1, ...) fails with EINVAL instead of EBADF.
