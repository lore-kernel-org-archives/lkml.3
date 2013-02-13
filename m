Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab3BMKFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:05:46 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35138 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817Ab3BMKFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:05:44 -0500
Date: Wed, 13 Feb 2013 11:05:43 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: initramfs@vger.kernel.org, Maximilian Attems <maks@debian.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [REGRESSION] [nailed] USB boot failure: USB: EHCI: make ehci-pci
 a separate driver
Message-ID: <20130213100543.GA20222@rhlx01.hs-esslingen.de>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130210001442.GA5744@rhlx01.hs-esslingen.de>
 <20130210140554.GA5299@rhlx01.hs-esslingen.de>
 <20130212160727.GA15857@rhlx01.hs-esslingen.de>
 <20130212161617.GA3887@kroah.com>
 <20130213064436.GA22583@rhlx01.hs-esslingen.de>
 <20130213071628.GA4211@rhlx01.hs-esslingen.de>
 <20130213074409.GA16043@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213074409.GA16043@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indeed,
adding

ehci_pci

to /etc/initramfs-tools/modules and running

update-initramfs -u -k 3.7.0-rc5+

to get /boot/initrd.img-3.7.0-rc5+
of the formerly broken -rc5+ build corrected
manages to fix boot.

On Wed, Feb 13, 2013 at 08:44:09AM +0100, Andreas Mohr wrote:
>   (is there a way to cleanly provide the accurately updated list
>   from the kernel side? Or is there a scripted mechanism to at least extract
>   all required *dependee* modules from the list of the ones that we
>   already know of? That would have saved our a** here...)

Wouldn't have...
ehci-pci is the new top-level depender on ehci-hcd, not the other way
around.
Unfortunately such a change is even more insidious since one cannot pick
up the change in an automated manner (via dependency inspection).

A more automated yet KISS solution for initramfs dependency stuff would
be desireable if perhaps unfeasible.

Andreas Mohr
