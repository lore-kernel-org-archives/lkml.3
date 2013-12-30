Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab3L3TkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 14:40:07 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45748 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3L3TkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 14:40:05 -0500
References: <cover.1388409686.git.liwang@ubuntukylin.com> <52C1C6F7.8010809@intel.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <52C1C6F7.8010809@intel.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <FFE7C704-791E-4B73-9251-EFB9135AB254@dilger.ca>
Cc: Li Wang <liwang@ubuntukylin.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Zefan Li <lizefan@huawei.com>,
        Matthew Wilcox <matthew@wil.cx>
X-Mailer: iPhone Mail (11B554a)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/3] Fadvise: Directory level page cache cleaning support
Date: Mon, 30 Dec 2013 12:40:05 -0700
To: Dave Hansen <dave.hansen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2013, at 12:18, Dave Hansen <dave.hansen@intel.com> wrote:
> 
> Why is this necessary to do in the kernel?  Why not leave it to
> userspace to walk the filesystem(s)?

I would suspect that trying to do it in userspace would be quite bad. It would require traversing the whole directory tree to issue cache flushed for each subdirectory, but it doesn't know when to stop traversal. That would mean the "cache flush" would turn into "cache pollute" and cause a lot of disk IO for subdirectories not in cache to begin with. 

Cheers, Andreas