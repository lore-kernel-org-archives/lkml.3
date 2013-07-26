Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab3GZOwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:52:40 -0400
Received: from longford.logfs.org ([213.229.74.203]:59921 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758998Ab3GZOwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:52:38 -0400
Date: Fri, 26 Jul 2013 09:20:34 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Dhaval Giani <dgiani@mozilla.com>, Taras Glek <tglek@mozilla.com>,
        linux-kernel@vger.kernel.org, tytso@mit.edu, vdjeric@mozilla.com,
        glandium@mozilla.com, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Message-ID: <20130726132034.GB21977@logfs.org>
References: <1374699833.7083.2.camel@localhost>
 <20130724233628.GD3641@logfs.org>
 <51F14136.30409@mozilla.com>
 <51F1556A.20909@mozilla.com>
 <51FB2C87-854F-4250-9587-B5BBF4E85EE8@dubeyko.com>
 <51F17005.7030309@mozilla.com>
 <1374825683.3671.35.camel@slavad-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374825683.3671.35.camel@slavad-ubuntu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 July 2013 12:01:23 +0400, Vyacheslav Dubeyko wrote:
> 
> We are discussing not about good or bad idea. We need to elaborate a
> right solution. I think that suggested idea is not clear. Do you want to
> support compression in ext4? Or do you want to add some new compression
> feature (likewise file-oriented compression)? If we are talking about
> compression in ext4 then it needs to use e2compr patch set. Otherwise,
> if we are talking about file compression then it is not question of
> concrete filesystem. And we need to make implementation on VFS level. It
> is only architectural point of view.

I don't think the e2compr patches are strictly necessary.  They are a
good option, but not the only one.

One trick to simplify the problem is to make Dhaval's compressed files
strictly read-only.  It will require some dance to load the compressed
content, flip the switch, then uncompress data on the fly and disallow
writes.  Not the most pleasing of interfaces, but yet another option.

> Why do you try to implement likewise concept on kernel level? It looks
> like you try to move some user-space concept in kernel-space.

The kernel controls the page cache.  Once the page cache is filled
with uncompressed file content, you can do mmap, regular file io, etc.
Putting uncompression code into the kernel makes sense to me.  Whether
a solution different from e2compr makes sense is yet to be seen.

Whatever you do, it will require support from the on-disk format and
the userspace ABI.  Setting the compression bit on a file has the
clear advantage that it is an established interface and also supported
by other filesystems.  Introducing yet another interface requires a
fairly strong case to be made.  But who knows, maybe Dhaval can pull
it off.

Jörn

--
Measuring programming progress by lines of code is like measuring aircraft
building progress by weight.
-- Bill Gates
