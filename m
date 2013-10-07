Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab3JGGur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:50:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab3JGGup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:50:45 -0400
Message-ID: <1381128633.13574.3.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH 1/2] hyperv-fb: add pci stub
From: Gerd Hoffmann <kraxel@redhat.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "open list:Hyper-V CORE AND..." <devel@linuxdriverproject.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 07 Oct 2013 08:50:33 +0200
In-Reply-To: <465ef0cb45e04bcc94c4788c0d930c4d@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1380714911-6254-1-git-send-email-kraxel@redhat.com>
	 <465ef0cb45e04bcc94c4788c0d930c4d@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, 2013-10-02 at 14:29 +0000, KY Srinivasan wrote:
> 
> > This patch adds a pci stub driver to hyper-fb.  The hyperv framebuffer
> > driver will bind to the pci device then, so linux kernel and userspace
> > know there is a proper kernel driver for the device active.  lspci shows
> > this for example:

> Gerd,
> 
> Thanks for doing this. This certainly will address some of the issues that are reported. I do have a question though - how would this work if we don't have PCI bus in the guest.

The hyperv framebuffer driver wouldn't work in the first place then as
it looks up the framebuffer address in pci config space (see hvfb_getmem
function).

cheers,
  Gerd



