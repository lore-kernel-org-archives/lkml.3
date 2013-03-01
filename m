Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3CAPlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:41:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab3CAPlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:41:07 -0500
Subject: Re: security_inode_init_security() inode field requirements
From: Steven Whitehouse <swhiteho@redhat.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        Chris Wright <chrisw@sous-sol.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CACLa4psWBYPDjiZB3ROA4yGTbJX=UmN3Go8xH_myZ+_W7D01AA@mail.gmail.com>
References: <1362132778.2723.15.camel@menhir>
	 <1362140849.9158.108.camel@falcor1> <1362143512.2723.21.camel@menhir>
	 <1362146843.9158.134.camel@falcor1>
	 <CACLa4psWBYPDjiZB3ROA4yGTbJX=UmN3Go8xH_myZ+_W7D01AA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 01 Mar 2013 15:38:44 +0000
Message-ID: <1362152324.2723.32.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2013-03-01 at 10:13 -0500, Eric Paris wrote:
> SELinux has no maximum   :-(
> 
> Realistically there are a couple of interfaces that limit things to
> 4k, but labels on files on disk could be even larger than that!
> 
> 255 will fit most every label, but not necessarily all of them.
> 
> 
> I know ext4 on Fedora allocates inodes which left about 255 bytes for
> selinux.selinux, but will place the xattr in another block if it
> happens to be larger than 255.  This is rare, but certainly
> possible....
> 
> We use the inode->i_mode.
> 
> In debug/error path we use:
>   inode->i_sb inode->i_no
> 
> We could use the parent dir sb instead of the new inode->i_sb.  We
> don't have to print the i_no when we hit a failure, but it is just
> about the only information that can help for debugging/figuring out
> which file had a failure..
> 
> -Eric
> 
So it sounds like setting the selinux label before the allocation of the
inode wouldn't be too much of a problem. That would give us the size
ahead of time. Maybe EVM is the only thing which needs to be an
exception in terms of being done after the inode number is set, and if
that has a fairly small maximum size, then that could still work I
think.

Having said that, this is turning out to be a fair bit more complicated
than I'd hoped :(

Steve.




