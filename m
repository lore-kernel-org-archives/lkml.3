Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3AXKj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:39:57 -0500
Received: from mx0.aculab.com ([213.249.233.131]:55743 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752824Ab3AXKjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:39:49 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] vhost-net: fall back to vmalloc if high-order allocation fails
Date: Thu, 24 Jan 2013 10:37:39 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B711F@saturn3.aculab.com>
In-Reply-To: <20130124100600.GB8710@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] vhost-net: fall back to vmalloc if high-order allocation fails
Thread-Index: Ac36GY74Ihw/ENfFRJiOMJM66uclPgAA9lBg
References: <87k3r31vbc.fsf@silenus.orebokech.com> <AE90C24D6B3A694183C094C60CF0A2F6026B711E@saturn3.aculab.com> <20130124100600.GB8710@redhat.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Romain Francoise" <romain@orebokech.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think this means that kmalloc() is likely to be faster
> > (if it doesn't have to sleep), but that vmalloc() is
> > allocating from a much larger resource.
> >
> > This make me that that large allocations that are not
> > temporary should probably be allocated with vmalloc().
> 
> vmalloc has some issues for example afaik it's not backed by
> a huge page so  I think its use puts more stress on the TLB cache.

Thinks further ...
64bit systems are likely to have enough kernel VA to be able
to map all of physical memory into contiguous VA.

I don't know if Linux does that, but I know code to map it was added
to NetBSD amd64 in order to speed up kernel accesses to 'random'
pages - it might have been partially backed out due to bugs!

If physical memory is mapped like that then kmalloc() requests
can any of physical memory and be unlikely to fail - since user
pages can be moved in order to generate contiguous free blocks.

Doesn't help with 32bit systems - they had to stop mapping all
of physical memory into kernel space a long time ago.

	David



