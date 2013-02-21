Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3BUNv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 08:51:58 -0500
Received: from mx12.netapp.com ([216.240.18.77]:22621 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab3BUNv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 08:51:57 -0500
X-IronPort-AV: E=Sophos;i="4.84,709,1355126400"; 
   d="scan'208";a="24871362"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Ric Wheeler <rwheeler@redhat.com>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: New copyfile system call - discuss before LSF?
Thread-Topic: New copyfile system call - discuss before LSF?
Thread-Index: AQHOECfzherspfmEjEqBTzfvhb3EUJiE2wAA
Date: Thu, 21 Feb 2013 13:51:53 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
References: <512606DF.5050706@redhat.com>
In-Reply-To: <512606DF.5050706@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <6E2A42859CBB174792185AD5B42273D4@tahoe.netapp.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 12:37 +0100, Ric Wheeler wrote:
> We have debated the need to have a system call to allow for offloading copy 
> operations, for example to an NFS server (part to the new NFS 4.2 
> specification), SCSI target device (two different SCSI commands do this), local 
> file systems (reflink, etc) and I suspect many other possible parts of the stack 
> could implement this.

sendfile64() pretty much already has the right arguments for a
"copyfile", however it would be nice to add a 'flags' parameter: the
NFSv4.2 version would use that to specify whether or not to copy file
metadata.

> The earliest discussion of such a system call I saw happened back in 2001, I 
> know we had another more recent flurry (2-3 years back?) as well that got 
> tangled up and died away.
>
> Given the new popularity of this in storage devices and the use case for virt 
> guests, any chance to get a proposal floated this year that might be able to 
> land upstream in our life times :) ?

I'm planning on soon dusting off the NFS prototype that NetApp wrote 3
years ago and converting at least the client implementation into
something that can go upstream. We do also have a server prototype for
Linux, but the copy offload between 2 different servers is a hack and
would need significant work.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
