Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbbATQiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:38:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbbATQiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:38:04 -0500
Date: Tue, 20 Jan 2015 18:38:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 00/16] virtio-pci: towards virtio 1.0 guest support
Message-ID: <20150120163800.GB1785@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
 <1421356698.3933.18.camel@nilsson.home.kraxel.org>
 <20150115213256.GA4813@redhat.com>
 <1421397146.21318.16.camel@nilsson.home.kraxel.org>
 <20150116084541.GA29204@redhat.com>
 <1421414833.21318.67.camel@nilsson.home.kraxel.org>
 <1421664883.3610.1.camel@nilsson.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421664883.3610.1.camel@nilsson.home.kraxel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 11:54:43AM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > I'm running 3.19-rc4 with this series applied in the guest, maybe I need
> > more?
> 
> Tried your vhost branch, rebased to 3.19-rc5 -- same result.  Hmm.
> 
> cheers,
>   Gerd
> 

Yes, it was all completely broken.
Looks like after making what looked like cosmetic changes, I run legacy
driver on new qemu and new driver on legacy qemu, but never new driver
on new qemu.

And sure enough, the "cosmetic" change inverted the logic testing probe
routine for success.

Sorry about that :(

I now posted fixed up patches: seem to work with net and block for me.

The easiest way to get the is probably from my git trees.

Thanks a lot for the reports!

-- 
MST
