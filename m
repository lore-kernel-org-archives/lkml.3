Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3FGK5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:57:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab3FGK5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:57:02 -0400
Subject: Re: GFS2: Add atomic_open support
From: Steven Whitehouse <swhiteho@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jlayton@redhat.com,
        "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <20130606175312.GG13110@ZenIV.linux.org.uk>
References: <1370530212.2744.34.camel@menhir>
	 <20130606175312.GG13110@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 07 Jun 2013 11:54:29 +0100
Message-ID: <1370602469.2768.25.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2013-06-06 at 18:53 +0100, Al Viro wrote:
> On Thu, Jun 06, 2013 at 03:50:12PM +0100, Steven Whitehouse wrote:
> > 
> > The following patch implements atomic_open for GFS2. This is mostly
> > straightforward, however there is one corner case which I've had to
> > deal with, beyond what would normally be expected for a local
> > filesystem.
> 
> Broken - what will happen if you hit a symlink, for starters?  On everything
> handled locally you should just return finish_no_open(file, dentry) and
> let the caller deal with that; the only cases that might make sense to
> handle in ->atomic_open() are regular files and directories.  For gfs2 it
> should be just regular files.  While we are at it, do you even need
> ->private_data for gfs2 directories?

I'm brewing up another version of the patch at the moment, which I will
post shortly. I don't understand why GFS2 specifically would not want to
do this with both files and directories? Why would it be different to
other filesystems in that respect?

We do need private data for gfs2 directories because that is required
for flock which should work equally well on directories as on regular
files. Potentially we might allocate it later, on the first call to
flock for example, but it has been done at open time so that we don't
have to test for it on every flock call. Also I was hoping to put some
info in there to assist with directory readahead at some stage too,

Steve.


