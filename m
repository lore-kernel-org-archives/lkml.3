Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaEGIfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:35:14 -0400
Received: from plane.gmane.org ([80.91.229.3]:39967 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaEGIfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:35:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v3 00/20] USB support for Armada 38x and Armada 375
Date: Wed, 7 May 2014 08:33:10 +0000 (UTC)
Message-ID: <loom.20140507T102941-222@post.gmane.org>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 83.85.80.13 (Mozilla/5.0 (X11; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

Gregory CLEMENT <gregory.clement <at> free-electrons.com> writes:

> This patch set adds the USB support for the Armada 38x Armada
> 375. These SoCs use an xHCI but still need specific initialization,
> mainly to setup the windows memory on the mbus. They also use the same
> controller that the other mvebu SoC for EHCI.

<snip>

> Gregory CLEMENT (20):
>   usb: ehci-orion: Fix clock reference leaking
>   usb: ehci-orion: Add the optional PHY support

If you're using a proper phy driver, do you really need a soc specific ehci
driver? I've spend a lot of time during the last release cycle to make
ehci-platform a lot more generic, including adding (optional) phy support to
it. It would be great if the new Armada SoCs could use ehci-platform instead
of extending ehci-orion to cover more models (ideally most ehci-foo drivers
would go away completely). I've no idea how feasible it is to use
ehci-platform in your case, but IMHO it should at least be considered.

Regards,

Hans


