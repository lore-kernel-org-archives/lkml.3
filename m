Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3LMLFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:05:22 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39945 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab3LMLFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:05:21 -0500
Date: Fri, 13 Dec 2013 11:05:20 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: Reserve minor for VFIO
Message-ID: <20131213110520.6db1ad99@alan.etchedpixels.co.uk>
In-Reply-To: <20131212184717.966.76895.stgit@bling.home>
References: <20131212184402.966.34502.stgit@bling.home>
	<20131212184717.966.76895.stgit@bling.home>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> VFIO currently allocates it's own dynamic chardev range, reserving the
> first minor for the control part of the interface (/dev/vfio/vfio) and
> the remainder for VFIO groups (/dev/vfio/$GROUP).  This works, but it
> doesn't support auto loading.  For instance when libvirt checks for
> VFIO support it looks for /dev/vfio/vfio, which currently doesn't
> exist unless the vfio module is loaded.  By converting the control
> device to a misc driver and reserving a static minor, we can enable
> auto loading.

Looks sensible to me. I'm not sure if Lanana even really goes anywhere
any more however. Linus kept complaining about static device numbering
despite the fact it's still essential for a few odd cases like this.

Alan
