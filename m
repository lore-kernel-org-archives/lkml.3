Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3LKTMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:12:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42523 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3LKTMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:12:03 -0500
Date: Wed, 11 Dec 2013 19:11:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: sougata@tuxera.com, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Szabolcs Szakacsits <szaka@tuxera.com>
Subject: Re: [PATCH] hfsplus: Remove hfsplus_file_lookup
Message-ID: <20131211191153.GZ10323@ZenIV.linux.org.uk>
References: <1386780980.9524.10.camel@ultrabook>
 <AE333CDA-DD74-42B8-92F4-551ACCAD8AFA@dubeyko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE333CDA-DD74-42B8-92F4-551ACCAD8AFA@dubeyko.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 10:49:29PM +0300, Vyacheslav Dubeyko wrote:

> This feature worked earlier under Linux. So, I suppose that some changes in HFS+ driver
> or in VFS broke it. And it needs to investigate and fix the reported issue. Thank you for the
> report.

This "feature" is severely broken and yes, outright removal is what I'd
suggest for a fix.  HFS+ allows hardlinks to files, which means that
you allow multiple dentries for the same inode with ->lookup() in it,
which is asking for deadlocks.

This is fundamentally not supported.  Considering that forks are lousy
idea in the first place, I'd seriously suggest to remove that idiocy for
good.
