Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaJFPZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:25:36 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:54778 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaJFPZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:25:34 -0400
Date: Mon, 6 Oct 2014 17:25:25 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 04/15] virtio: defer config changed notifications
Message-ID: <20141006172525.4b663de6.cornelia.huck@de.ibm.com>
In-Reply-To: <1412608214-31944-5-git-send-email-mst@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
	<1412608214-31944-5-git-send-email-mst@redhat.com>
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
x-cbid: 14100615-5024-0000-0000-0000018D9A8F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014 18:10:55 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Defer config changed notifications that arrive during
> probe/scan/freeze/restore.
> 
> This will allow drivers to set DRIVER_OK earlier, without worrying about
> racing with config change interrupts.
> 
> This change will also benefit old hypervisors (before 2009)
> that send interrupts without checking DRIVER_OK: previously,
> the callback could race with driver-specific initialization.
> 
> This will also help simplify drivers.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio.h  |  6 ++++++
>  drivers/virtio/virtio.c | 57 +++++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 54 insertions(+), 9 deletions(-)

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

