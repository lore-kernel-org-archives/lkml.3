Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaK0LDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:03:02 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:45086 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbaK0LC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:02:59 -0500
Date: Thu, 27 Nov 2014 12:02:52 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Pawel Moll <pawel.moll@arm.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 04/42] virtio: disable virtio 1.0 in transports
Message-ID: <20141127120252.27021c54.cornelia.huck@de.ibm.com>
In-Reply-To: <20141127105434.GA10037@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-5-git-send-email-mst@redhat.com>
	<20141125182942.3890fe7b.cornelia.huck@de.ibm.com>
	<20141125212011.GA22343@redhat.com>
	<20141126100954.3811e594.cornelia.huck@de.ibm.com>
	<20141127105434.GA10037@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112711-0041-0000-0000-000002465FAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 12:54:34 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Wed, Nov 26, 2014 at 10:09:54AM +0100, Cornelia Huck wrote:

> > The old s390 virtio transport in kvm_virtio.c is not part of virtio 1.0.
> 
> It might or might not be a good idea to add code in kvm_virtio.c
> blacklisting VIRTIO_F_VERSION_1, just in case there's a buggy device
> that sets it.
> As correct devices won't set it, I don't think we need to
> worry about it too much. We can make it a patch on top later
> if we want.
> 

I'd want to blacklist it, just to make sure nothing weird happens. I
don't want to spend effort on the old transport beyond that :)

