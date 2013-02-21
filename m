Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3BUPyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:54:05 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:34565 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3BUPyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:54:03 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5r/UwZ5vFU8=
X-RZG-CLASS-ID: mo00
Date: Thu, 21 Feb 2013 16:53:59 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Message-ID: <20130221155359.GA28637@aepfle.de>
References: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
 <20130219165118.GA17715@aepfle.de>
 <1ca36b5d55c64ac6b8854c4f216ef8e5@DFM-TK5MBX15-06.exchange.corp.microsoft.com>
 <20130219184009.GA21783@aepfle.de>
 <7267f77544c24531b8fcccc2192b9f48@DFM-TK5MBX15-06.exchange.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7267f77544c24531b8fcccc2192b9f48@DFM-TK5MBX15-06.exchange.corp.microsoft.com>
User-Agent: Mutt/1.5.21.rev5638 (2013-02-08)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, Haiyang Zhang wrote:

> > I havent read the vesafb code, but I think it can kind of give up the
> > hardware, something ata_piix can not do.
> 
> In my test, the vesafb doesn't automatically give up the emulated video device,
> unless I add the DMI based mechanism to let it exit on Hyper-V.

>From reading the code, it seems to do that via
do_remove_conflicting_framebuffers(). hypervfb does not set apertures
etc, so that function is a noop.


My point is that with this new driver distro kernel will have no console
output until hypervfb is loaded. On native hardware there is at least
vesafb which can display something until initrd is running. So if the
hypervisor allows that hypervfb can shutdown the emulated vesa hardware
then it should do that.


Olaf
