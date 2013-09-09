Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3IIVI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:08:59 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56159 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3IIVI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:08:57 -0400
Date: Mon, 9 Sep 2013 23:08:50 +0200
From: Ross Lagerwall <rosslagerwall@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Trailing slash with symlinks and rmdir/rename
Message-ID: <20130909210850.GA9694@hobo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have noticed that if X is a symlink to a directory Y, doing "rmdir X/"
or "mv X/ Z" does not behave how I expect.

My reading of POSIX 2008 (and the behaviour of FreeBSD and OpenIndiana)
is that a symbolic link to a directory followed by a trailing slash
should behave as though it names the directory pointed to by the
symbolic link.

So while Linux gives ENOTDIR for "rmdir X/", the others remove Y.

Is this a bug?  If it is, I can have a go at writing a patch.

Regards
-- 
Ross Lagerwall
