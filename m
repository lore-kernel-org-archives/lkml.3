Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab3BUSh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:37:29 -0500
Received: from fn.samba.org ([216.83.154.106]:54471 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab3BUSh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:37:28 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2013 13:37:28 EST
Date: Thu, 21 Feb 2013 10:29:19 -0800
From: Jeremy Allison <jra@samba.org>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: New copyfile system call - discuss before LSF?
Message-ID: <20130221182919.GB13435@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <512606DF.5050706@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 01:51:53PM +0000, Myklebust, Trond wrote:
> On Thu, 2013-02-21 at 12:37 +0100, Ric Wheeler wrote:
> > We have debated the need to have a system call to allow for offloading copy 
> > operations, for example to an NFS server (part to the new NFS 4.2 
> > specification), SCSI target device (two different SCSI commands do this), local 
> > file systems (reflink, etc) and I suspect many other possible parts of the stack 
> > could implement this.
> 
> sendfile64() pretty much already has the right arguments for a
> "copyfile", however it would be nice to add a 'flags' parameter: the
> NFSv4.2 version would use that to specify whether or not to copy file
> metadata.

What would be really nice is if sendfile allowed zero-copy
from network socket to a file descriptor. That would help
a *lot* of my small system OEMs (and no splice() just doesn't
cut it :-).

Jeremy.
