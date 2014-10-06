Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaJFPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:16:28 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:56843 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaJFPQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:16:24 -0400
Date: Mon, 6 Oct 2014 17:16:14 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 02/15] virtio: unify config_changed handling
Message-ID: <20141006171614.376ba255.cornelia.huck@de.ibm.com>
In-Reply-To: <1412608214-31944-3-git-send-email-mst@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
	<1412608214-31944-3-git-send-email-mst@redhat.com>
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
x-cbid: 14100615-3548-0000-0000-000001C53FBC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014 18:10:44 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Replace duplicated code in all transports with a single wrapper in
> virtio.c.
> 
> The only functional change is in virtio_mmio.c: if a buggy device sends
> us an interrupt before driver is set, we previously returned IRQ_NONE,
> now we return IRQ_HANDLED.
> 
> As this must not happen in practice, this does not look like a big deal.
> 
> See also commit 3fff0179e33cd7d0a688dab65700c46ad089e934
> 	virtio-pci: do not oops on config change if driver not loaded.
> for the original motivation behind the driver check.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio.h             | 2 ++
>  drivers/misc/mic/card/mic_virtio.c | 6 +-----
>  drivers/s390/kvm/kvm_virtio.c      | 9 +--------
>  drivers/s390/kvm/virtio_ccw.c      | 6 +-----
>  drivers/virtio/virtio.c            | 9 +++++++++
>  drivers/virtio/virtio_mmio.c       | 7 ++-----
>  drivers/virtio/virtio_pci.c        | 6 +-----
>  7 files changed, 17 insertions(+), 28 deletions(-)

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

