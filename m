Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3BUUAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:00:53 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:52992 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3BUUAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:00:52 -0500
Message-ID: <51267CEB.8070805@redhat.com>
Date: Thu, 21 Feb 2013 21:00:43 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
CC: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
References: <512606DF.5050706@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com> <512635D2.4090207@redhat.com>
In-Reply-To: <512635D2.4090207@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/02/2013 15:57, Ric Wheeler ha scritto:
>>>
>> sendfile64() pretty much already has the right arguments for a
>> "copyfile", however it would be nice to add a 'flags' parameter: the
>> NFSv4.2 version would use that to specify whether or not to copy file
>> metadata.
> 
> That would seem to be enough to me and has the advantage that it is an
> relatively obvious extension to something that is at least not totally
> unknown to developers.
> 
> Do we need more than that for non-NFS paths I wonder? What does reflink
> need or the SCSI mechanism?

For virt we would like to be able to specify arbitrary block ranges.
Copying an entire file helps some copy operations like storage
migration.  However, it is not enough to convert the guest's offloaded
copies to host-side offloaded copies.

Paolo
