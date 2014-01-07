Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaAGPHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:07:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26550 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaAGPG5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:06:57 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: status of block-integrity
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20140107013646.GB10297@birch.djwong.org>
Date: Tue, 7 Jan 2014 10:06:14 -0500
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        LKML Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DECA4257-97BB-4E25-96D7-612B500630AC@oracle.com>
References: <20131222192128.GA28532@infradead.org> <52C6D0DB.1050906@suse.de> <yq1wqigzvc1.fsf@sermon.lab.mkp.net> <20140107013646.GB10297@birch.djwong.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
X-Mailer: Apple Mail (2.1827)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 6, 2014, at 8:36 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Fri, Jan 03, 2014 at 03:03:42PM -0500, Martin K. Petersen wrote:
>>>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
>> 
>> Hannes> Personally, I doubt it's a good idea to kill it off, but a
>> Hannes> proper (userland) API for it has been a long time missing.
>> 
>> Before we throw the baby out with the bath water, maybe Darrick can fill
>> us in on the progress of the aio passthrough interface?
> 
> I haven't made much progress on it -- I haven't seen any earnest demand for it.
> 
> Last year Chuck Lever said that some NFS working group was looking defining an
> interface it... has there been any progress?  It doesn't sound like there has
> been.

You must be thinking of some other Chuck Lever ;-)

What I promised to deliver was plumbing in the NFS protocol to support end-to-end data integrity.  That's here:

  https://datatracker.ietf.org/doc/draft-cel-nfsv4-end2end-data-protection/

The issue of system call API is as sticky for NFS as it is for other e2e implementations.  Without an API, other projects have been allowed to take up the time I would have spent on an NFS prototype.

What's more, some of the fields in the T10 tag are meaningless for byte-stream: an application, for example, will know nothing of block addresses, since those are chosen by the underlying filesystem.  NFS (or any byte stream e2e integrity API) will have to define a different protection envelope with perhaps different tag contents.

But we do have a range of potential use cases for NFS: hypervisors that emulate block devices using NFS files, strong cryptographic data checksums, and of course the Oracle database.  No real demand, as others have said.

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com

