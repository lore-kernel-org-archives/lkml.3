Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbaKMJPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:15:12 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:48238 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaKMJPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:15:02 -0500
Date: Thu, 13 Nov 2014 10:14:56 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] virito: introduce methods of fixing device features
Message-ID: <20141113101456.43acfdb7.cornelia.huck@de.ibm.com>
In-Reply-To: <546475C2.50606@redhat.com>
References: <1415857974-23326-1-git-send-email-jasowang@redhat.com>
	<20141113094604.1f248c3d.cornelia.huck@de.ibm.com>
	<546475C2.50606@redhat.com>
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
x-cbid: 14111309-0041-0000-0000-0000021AC6F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 17:11:30 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 11/13/2014 04:46 PM, Cornelia Huck wrote:
> > On Thu, 13 Nov 2014 13:52:53 +0800
> > Jason Wang <jasowang@redhat.com> wrote:

> >> +static inline void virtio_disable_feature(struct virtio_device *vdev,
> >> +                                          unsigned int fbit)
> >> +{
> >> +	BUG_ON(fbit >= VIRTIO_TRANSPORT_F_START);
> >> +	BUG_ON(vdev->config->get_status(vdev) &
> >> +	       ~(VIRTIO_CONFIG_S_ACKNOWLEDGE | VIRTIO_CONFIG_S_DRIVER));
> > When we add virtio-1 support, we can add a check for FEATURES_OK here,
> > so we're really on the safe side.
> >
> 
> If I read the spec correctly, FEATURES_OK was set only after writing the
> features bits to device. But we want to sanitize the them before.

I meant doing a BUG when FEATURES_OK is set - sorry for not being clear.

