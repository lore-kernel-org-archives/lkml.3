Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3JDX6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 19:58:35 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34709 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3JDX6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 19:58:33 -0400
Message-ID: <524F5625.4080807@mit.edu>
Date: Fri, 04 Oct 2013 16:58:29 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, tytso@mit.edu, mszeredi@suse.cz
Subject: Re: [RFC PATCH 0/7] cross rename
References: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
In-Reply-To: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
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

How hard would it be to also add RENAME_NOREPLACE that fails if the
destination already exists?

IMO this would get rid of the last sane use of hard links (link + unlink
to simulate non-clobbering rename), and it would be nice on filesystems
that don't have hard links.

Windows has supported this since Windows 98, IIRC (using MoveFileEx).

--Andy

