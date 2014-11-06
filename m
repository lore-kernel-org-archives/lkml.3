Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaKFXrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:47:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKFXrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:47:03 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-arch@vger.kernel.org, ceph-devel@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org
Subject: Re: [PATCH v5 7/7] fs: add a flag for per-operation O_DSYNC semantics
References: <cover.1415220890.git.milosz@adfin.com>
	<cover.1415220890.git.milosz@adfin.com>
	<c188b04ede700ce5f986b19de12fa617d158540f.1415220890.git.milosz@adfin.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 06 Nov 2014 18:46:08 -0500
In-Reply-To: <c188b04ede700ce5f986b19de12fa617d158540f.1415220890.git.milosz@adfin.com>
	(Milosz Tanski's message of "Wed, 5 Nov 2014 16:14:53 -0500")
Message-ID: <x49r3xf28qn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> writes:

> -		if (type == READ && (flags & RWF_NONBLOCK))
> -			return -EAGAIN;
> +		if (type == READ) {
> +			if (flags & RWF_NONBLOCK)
> +				return -EAGAIN;
> +		} else {
> +			if (flags & RWF_DSYNC)
> +				return -EINVAL;
> +		}

Minor nit, but I'd rather read something that looks like this:

	if (type == READ && (flags & RWF_NONBLOCK))
		return -EAGAIN;
	else if (type == WRITE && (flags & RWF_DSYNC))
		return -EINVAL;

I won't lose sleep over it, though.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
