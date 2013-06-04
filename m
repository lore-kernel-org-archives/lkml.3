Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab3FDQ2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:28:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38978 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755270Ab3FDQ2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:28:20 -0400
Message-ID: <1370363289.2385.41.camel@joe-AO722>
Subject: Re: [PATCH] jfs: Convert jfs_error to jfs_sb_err
From: Joe Perches <joe@perches.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Tue, 04 Jun 2013 09:28:09 -0700
In-Reply-To: <51AE0F37.3020104@oracle.com>
References: <76a131f2845ec3f75dd80be6808e513ae3ea4255.1370323137.git.joe@perches.com>
	 <51AE0F37.3020104@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-04 at 11:00 -0500, Dave Kleikamp wrote:
> I generally like this cleanup except for one thing.
> 
> On 06/04/2013 12:22 AM, Joe Perches wrote:
> > Use a more current logging style.
> > 
> > Rename function jfs_error to jfs_sb_err.
> 
> Why the rename? If you're going to rename it, the new name should be
> more descriptive, such as jfs_report_and_handle_error(), but I don't
> like that because it's too long. jfs_error() is similiar to ext4_error()
> or btrfs_error(). I don't understand the name change.

Pick a name.  I don't much care what it is really.

This one takes a super_block * and emits a logging message
so I chose jfs_sb_err to try to describe the sb * bit.

I like the _err suffix is a bit better than the
_error suffix as it's a bit more name consistent
with other kernel logging mechanisms like dev_err,
pr_err, etc, but if you want to remain consistent
with other fs/,,, fine by me.

I think the other fs _error names are sub-optimal.

These functions are a bit overloaded too when
CONFIG_PRINTK is not enabled.  The format and args
still exist in code and I believe can not be
optimized away by the compiler

I think using macro or an in-place expansion to
separate the 2 parts of the reporting and then the
handling of of the error would be better as it
would allow smaller embedded use.

> > Add __printf format and argument verification.
> 
> good

I submitted a patch a few years ago to do that too.
Dunno what happened to it,

> > Remove embedded function names from formats.
> > Add %pf, __builtin_return_address(0) to jfs_sb_err.
> 
> I like this.

It also reduces stack needs a bit by removing that
256 byte temp buffer.


