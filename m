Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3JCCAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 22:00:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40084 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab3JCCAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 22:00:24 -0400
Message-ID: <524CCF38.9000304@zytor.com>
Date: Wed, 02 Oct 2013 18:58:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, tytso@mit.edu, mszeredi@suse.cz
Subject: Re: [RFC PATCH 0/7] cross rename
References: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
In-Reply-To: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 09:00 AM, Miklos Szeredi wrote:
> This series adds a new syscall, renameat2(), which is the same as renameat() but
> with a flags argument.  Internally i_op->reaname2() is also added, which can
> later be merged with ->rename() but is kept separately for now, since this would
> just blow up this patch without helping review.
> 
> The purpose of extending rename is to add cross-rename, a symmetric variant of
> rename, which exchanges the two files.  This allows interesting things, which
> were not possible before, for example atomically replacing a directory tree with
> a symlink, etc...
> 

I would suggest it shouldn't be renameat2() but rather renameat3(), i.e.
rename file A -> B, if B exists rename B to C.  It may not be desirable
to expose the stale B in the same namespace as A, but still want it to
be possible to scavenge it.  Obviously, A=C is a valid subcase.

	-hpa


