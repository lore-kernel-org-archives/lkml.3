Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaBRHBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 02:01:21 -0500
Received: from senator.holtmann.net ([87.106.208.187]:51694 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaBRHBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 02:01:20 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH v2] Bluetooth: allocate static minor for vhci
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1392700766-4374-1-git-send-email-lucas.demarchi@intel.com>
Date: Mon, 17 Feb 2014 23:01:11 -0800
Cc: "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <BD98E109-FE9C-4F67-84AC-3CEA048641BE@holtmann.org>
References: <1392700766-4374-1-git-send-email-lucas.demarchi@intel.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lucas,

> Commit bfacbb9 (Bluetooth: Use devname:vhci module alias for virtual HCI
> driver) added the module alias to hci_vhci module so it's possible to
> create the /dev/vhci node. However creating an alias without
> specifying the minor doesn't allow us to create the node ahead,
> triggerring module auto-load when it's first accessed.
> 
> Starting with depmod from kmod 16 we started to warn if there's a
> devname alias without specifying the major and minor.
> 
> Let's do the same done for uhid, kvm, fuse and others, specifying a
> fixed minor. In systems with systemd as the init the following will
> happen: on early boot systemd will call "kmod static-nodes" to read
> /lib/modules/$(uname -r)/modules.devname and then create the nodes. When
> first accessed these "dead" nodes will trigger the module loading.
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
> ---
> 
> Changes from v1:
> - use minor=137, since 240 is reserved for local use
> 
> We talked about using 197, but that's being used by pxa3xx-gcu, too.

looks fine to me. If Kay and/or Greg want to ack it, then I take it through bluetooth-next tree.

Regards

Marcel

