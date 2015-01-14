Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbbANPd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:33:27 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:38617 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbbANPd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:33:26 -0500
Date: Wed, 14 Jan 2015 18:33:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Calvin Owens <calvinowens@fb.com>,
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
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Message-ID: <20150114153323.GF2253@moon>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
 <20150114152501.GB9820@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114152501.GB9820@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 05:25:01PM +0200, Kirill A. Shutemov wrote:
...
> > 
> > This gives lsof and suchlike a way to determine the pathnames of files
> > mapped into a process without incurring the O(N^2) behavior of the
> > maps file.
> 
> We already have /proc/PID/map_files/ directory which lists all mapped
> files. Should we consider relaxing permission checking there and move it
> outside CONFIG_CHECKPOINT_RESTORE instead?
> 
> Restriction to CAP_SYSADMIN for follow_link is undertansble, but why do we
> restrict readdir and readlink?

We didn't think this functionality might be needed someone but us (criu camp),
so that the rule of thumb was CONFIG_CHECKPOINT_RESTORE + CAP_SYSADMIN, until
otherwise strictly needed. So I think now we can relax security rules a bit
and allow to readdir and such for owners.

	Cyrill
