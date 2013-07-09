Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab3GIPjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:39:20 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:36232 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab3GIPjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:39:16 -0400
Date: Tue, 9 Jul 2013 11:39:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Message-ID: <20130709153907.GA17972@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
	cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org
References: <20130708100046.14417.12932.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708100046.14417.12932.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another major problem with this concept is that it lumps all I/O's
into a single cgroup.  So I/O's from pseudo filesystems (such as
reading from /sys/kernel/debug/tracing/trace_pipe), networked file
systems such as NFS, and I/O to various different block devices all
get counted in a single per-cgroup limit.

This doesn't seem terribly useful to me.  Network resources and block
resources are quite different, and counting pseudo file systems and
ram disks makes no sense at all.

Regards,

					- Ted
