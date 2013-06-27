Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3F0Q0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:26:50 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:37562 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3F0Q0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:26:48 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Whitcroft <apw@canonical.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 0/3] overlayfs fixes for v3.8 and later base
Date: Thu, 27 Jun 2013 17:26:41 +0100
Message-Id: <1372350404-10359-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following this email are three patches against overlayfs.v17 which allow
it to work against v3.10-rc6 and later.  With these applied overlayfs
passes basic testing.

overlayfs -- ovl_path_open should not take path reference

    Found this in testing on Ubuntu raring, testing against loopback
    mounted files.  Without this change we were unable to release the
    loopback device for reuse.  Looking at it actually we were also leaking
    references on the root filesystem, but these are not as obvious.

vfs: export do_splice_direct() to modules -- fix
overlayfs -- follow change to do_splice_direct interface

    This pair switch us to the new do_splice_direct interface.  Note that
    the first one is effectivly a fix for the existing export of this
    interface and likely should be merged down into it.

Please consider for your overlayfs branch.

-apw
