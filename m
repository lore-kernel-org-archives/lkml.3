Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab3BUWGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:06:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab3BUWGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:06:33 -0500
Message-ID: <51269A2B.7070000@redhat.com>
Date: Thu, 21 Feb 2013 23:05:31 +0100
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
References: <512606DF.5050706@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com> <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com>
In-Reply-To: <51267CEB.8070805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 09:00 PM, Paolo Bonzini wrote:
> Il 21/02/2013 15:57, Ric Wheeler ha scritto:
>>> sendfile64() pretty much already has the right arguments for a
>>> "copyfile", however it would be nice to add a 'flags' parameter: the
>>> NFSv4.2 version would use that to specify whether or not to copy file
>>> metadata.
>> That would seem to be enough to me and has the advantage that it is an
>> relatively obvious extension to something that is at least not totally
>> unknown to developers.
>>
>> Do we need more than that for non-NFS paths I wonder? What does reflink
>> need or the SCSI mechanism?
> For virt we would like to be able to specify arbitrary block ranges.
> Copying an entire file helps some copy operations like storage
> migration.  However, it is not enough to convert the guest's offloaded
> copies to host-side offloaded copies.
>
> Paolo

I don't think that the NFS protocol allows arbitrary ranges, but the SCSI 
commands are ranged based.

If I remember what the windows people said at a SNIA event a few years back, 
they have a requirement that the target file be pre-allocated (at least for the 
SCSI based copy). Not clear to me where they iterate over that target file to do 
the block range copies, but I suspect it is in their kernel.

Ric

