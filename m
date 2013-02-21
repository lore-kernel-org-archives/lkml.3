Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab3BUWOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:14:02 -0500
Received: from mx12.netapp.com ([216.240.18.77]:56876 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756483Ab3BUWOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:14:00 -0500
X-IronPort-AV: E=Sophos;i="4.84,711,1355126400"; 
   d="scan'208";a="25004198"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Ric Wheeler <rwheeler@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, "Joel Becker" <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Thread-Topic: New copyfile system call - discuss before LSF?
Thread-Index: AQHOECfzherspfmEjEqBTzfvhb3EUJiE2wAAgAASTQCAAFTBgIAAIt+AgAACYQA=
Date: Thu, 21 Feb 2013 22:13:57 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAE3B@SACEXCMBX04-PRD.hq.netapp.com>
References: <512606DF.5050706@redhat.com>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
	 <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com>
	 <51269A2B.7070000@redhat.com>
In-Reply-To: <51269A2B.7070000@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <C904D037C1D813458D934D0079666813@tahoe.netapp.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 23:05 +0100, Ric Wheeler wrote:
> On 02/21/2013 09:00 PM, Paolo Bonzini wrote:
> > Il 21/02/2013 15:57, Ric Wheeler ha scritto:
> >>> sendfile64() pretty much already has the right arguments for a
> >>> "copyfile", however it would be nice to add a 'flags' parameter: the
> >>> NFSv4.2 version would use that to specify whether or not to copy file
> >>> metadata.
> >> That would seem to be enough to me and has the advantage that it is an
> >> relatively obvious extension to something that is at least not totally
> >> unknown to developers.
> >>
> >> Do we need more than that for non-NFS paths I wonder? What does reflink
> >> need or the SCSI mechanism?
> > For virt we would like to be able to specify arbitrary block ranges.
> > Copying an entire file helps some copy operations like storage
> > migration.  However, it is not enough to convert the guest's offloaded
> > copies to host-side offloaded copies.
> >
> > Paolo
> 
> I don't think that the NFS protocol allows arbitrary ranges, but the SCSI 
> commands are ranged based.
> 
> If I remember what the windows people said at a SNIA event a few years back, 
> they have a requirement that the target file be pre-allocated (at least for the 
> SCSI based copy). Not clear to me where they iterate over that target file to do 
> the block range copies, but I suspect it is in their kernel.

The NFSv4.2 copy offload protocol _does_ allow the copying of arbitrary
byte ranges. The main target for that functionality is indeed
virtualisation and thin provisioning of virtual machines.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
