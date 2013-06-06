Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3FFRxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:53:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36593 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab3FFRxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:53:14 -0400
Date: Thu, 6 Jun 2013 18:53:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jlayton@redhat.com,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: GFS2: Add atomic_open support
Message-ID: <20130606175312.GG13110@ZenIV.linux.org.uk>
References: <1370530212.2744.34.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370530212.2744.34.camel@menhir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 03:50:12PM +0100, Steven Whitehouse wrote:
> 
> The following patch implements atomic_open for GFS2. This is mostly
> straightforward, however there is one corner case which I've had to
> deal with, beyond what would normally be expected for a local
> filesystem.

Broken - what will happen if you hit a symlink, for starters?  On everything
handled locally you should just return finish_no_open(file, dentry) and
let the caller deal with that; the only cases that might make sense to
handle in ->atomic_open() are regular files and directories.  For gfs2 it
should be just regular files.  While we are at it, do you even need
->private_data for gfs2 directories?
