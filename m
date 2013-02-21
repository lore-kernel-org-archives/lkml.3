Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3BUUud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:50:33 -0500
Received: from mx12.netapp.com ([216.240.18.77]:13170 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab3BUUua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:50:30 -0500
X-IronPort-AV: E=Sophos;i="4.84,711,1355126400"; 
   d="scan'208";a="24985303"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, "Joel Becker" <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Thread-Topic: New copyfile system call - discuss before LSF?
Thread-Index: AQHOECfzherspfmEjEqBTzfvhb3EUJiE2wAAgAASTQCAAFTBgIAADekA
Date: Thu, 21 Feb 2013 20:50:27 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
References: <512606DF.5050706@redhat.com>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
	 <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com>
In-Reply-To: <51267CEB.8070805@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <C8902FA0A4371E46A2000C756EFAF789@tahoe.netapp.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 21:00 +0100, Paolo Bonzini wrote:
> Il 21/02/2013 15:57, Ric Wheeler ha scritto:
> >>>
> >> sendfile64() pretty much already has the right arguments for a
> >> "copyfile", however it would be nice to add a 'flags' parameter: the
> >> NFSv4.2 version would use that to specify whether or not to copy file
> >> metadata.
> > 
> > That would seem to be enough to me and has the advantage that it is an
> > relatively obvious extension to something that is at least not totally
> > unknown to developers.
> > 
> > Do we need more than that for non-NFS paths I wonder? What does reflink
> > need or the SCSI mechanism?
> 
> For virt we would like to be able to specify arbitrary block ranges.
> Copying an entire file helps some copy operations like storage
> migration.  However, it is not enough to convert the guest's offloaded
> copies to host-side offloaded copies.

So how would a system call based on sendfile64() plus my flag parameter
prevent an underlying implementation from meeting your criterion?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
