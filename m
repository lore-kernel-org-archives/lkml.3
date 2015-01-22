Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbbAVHQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:16:45 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:50915 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbAVHQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:16:38 -0500
Date: Thu, 22 Jan 2015 10:16:35 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Calvin Owens <calvinowens@fb.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][PATCH] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Message-ID: <20150122071635.GM3676@moon>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
 <20150114152501.GB9820@node.dhcp.inet.fi>
 <20150114153323.GF2253@moon>
 <20150114204653.GA26698@mail.thefacebook.com>
 <20150114211613.GH2253@moon>
 <20150122024554.GB23762@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122024554.GB23762@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 06:45:54PM -0800, Calvin Owens wrote:
> Currently, /proc/<pid>/map_files/ is restricted to CAP_SYS_ADMIN, and
> is only exposed if CONFIG_CHECKPOINT_RESTORE is set. This interface
> is very useful for enumerating the files mapped into a process when
> the more verbose information in /proc/<pid>/maps is not needed.
> 
> This patch moves the folder out from behind CHECKPOINT_RESTORE, and
> removes the CAP_SYS_ADMIN restrictions. To avoid exposing files to
> processes for whom they may not be visible, a follow_link() stub is
> added to the inode_operations struct attached to the symlinks that
> prevent them from being followed without CAP_SYS_ADMIN.
> 
> Signed-off-by: Calvin Owens <calvinowens@fb.com>

Looks good to me, thanks.
