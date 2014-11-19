Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaKSJOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:14:49 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:52480 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaKSJOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:14:45 -0500
Date: Wed, 19 Nov 2014 10:14:36 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH net] virtio-net: validate features during probe
Message-ID: <20141119101436.3b72989c.cornelia.huck@de.ibm.com>
In-Reply-To: <20141119085939.GB24827@redhat.com>
References: <1416378939-28821-1-git-send-email-jasowang@redhat.com>
	<20141119085939.GB24827@redhat.com>
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
x-cbid: 14111909-0041-0000-0000-0000022C79A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 10:59:39 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:


> +bool __virtnet_fail_on_feature(struct virtio_device *vdev, unsigned int fbit,
> +			       const char *fname)
> +{
> +	if (!virtio_has_feature(vdev, fbit))
> +		return false;
> +
> +        dev_err(&dev->dev, "missing requirements for feature bit %d: %s\n",
> +		fbit, fname);

I'd like the message to point out that this is a hypervisor problem: I
can imagine that a user would be stumped about what to do about this.
And printing what requirements are missing would probably be helpful to
someone trying to fix the hypervisor.

> +
> +	return true;
> +}
> +
>

