Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3BUQhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:37:43 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57388 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3BUQhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:37:41 -0500
Subject: Re: New copyfile system call - discuss before LSF?
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <512635D2.4090207@redhat.com>
Date: Thu, 21 Feb 2013 09:36:12 -0700
Cc: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6CEF377E-088F-4A79-896E-074CBC61CD8E@dilger.ca>
References: <512606DF.5050706@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com> <512635D2.4090207@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-21, at 7:57 AM, Ric Wheeler wrote:
> On 02/21/2013 02:51 PM, Myklebust, Trond wrote:
>> On Thu, 2013-02-21 at 12:37 +0100, Ric Wheeler wrote:
>>> We have debated the need to have a system call to allow for offloading copy
>>> operations, for example to an NFS server (part to the new NFS 4.2
>>> specification), SCSI target device (two different SCSI commands do this), local
>>> file systems (reflink, etc) and I suspect many other possible parts of the stack
>>> could implement this.
>> sendfile64() pretty much already has the right arguments for a
>> "copyfile", however it would be nice to add a 'flags' parameter: the
>> NFSv4.2 version would use that to specify whether or not to copy file
>> metadata.
> 
> That would seem to be enough to me and has the advantage that it is an relatively obvious extension to something that is at least not totally unknown to developers.
> 
> Do we need more than that for non-NFS paths I wonder? What does reflink need or the SCSI mechanism?

IMHO, the critical part about a copy syscall is avoiding the data
copy to/from userspace.  Copying file attributes opens up a huge
morass of issues related to which attrs/xattrs/ACLs are copied,
yet those don't cost nearly so much as the data copies.

We definitely want the API to be flexible enough to do server-side
copies (e.g. NFS and CIFS), but we also need to allow data copies
for regular files between different local and/or network filesystems
within the VFS.

Cheers, Andreas

>>> The earliest discussion of such a system call I saw happened back in 2001, I
>>> know we had another more recent flurry (2-3 years back?) as well that got
>>> tangled up and died away.
>>> 
>>> Given the new popularity of this in storage devices and the use case for virt
>>> guests, any chance to get a proposal floated this year that might be able to
>>> land upstream in our life times :) ?
>> I'm planning on soon dusting off the NFS prototype that NetApp wrote 3
>> years ago and converting at least the client implementation into
>> something that can go upstream. We do also have a server prototype for
>> Linux, but the copy offload between 2 different servers is a hack and
>> would need significant work.
>> 
> 
> That would be really interesting, thanks!
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

