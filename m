Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaKXSsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:48:41 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:32792 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaKXSsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:48:40 -0500
Date: Mon, 24 Nov 2014 19:48:31 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 00/41] linux: towards virtio-1 guest support
Message-ID: <20141124194831.252318e4.cornelia.huck@de.ibm.com>
In-Reply-To: <1416829787-14252-1-git-send-email-mst@redhat.com>
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
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
x-cbid: 14112418-0041-0000-0000-0000023C5EAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 13:52:32 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Based on patches by Cornelia Rusty and others, but
> with an API that should allow better static checking of code,
> and slightly more concervative changes in vring,net and blk.
> 
> Based on patches by Cornelia and others, but
> with an API that should allow better static checking of code,
> slightly more concervative changes in vring and drivers,
> and compatibility for existing drivers so that
> this series be applied before all drivers are converted.
> 
> virtio net,blk and scsi drivers have been converted.
> They now pass sparse without warnings.
> 
> net and blk patches have been tested on s390.

vring_transport_features() seems to knock off the version 1 bit (I
wonder why I did not see that before, maybe VIRTIO_TRANSPORT_F_END had
not been increased before?). If I add VIRTIO_F_VERSION_1 in this
function, virtio-net and virtio-blk seem to work fine with version 1 on
virtio-ccw (tested with my old virtio-1 qemu branch).

I'll try to do a bit of reviewing tomorrow.

