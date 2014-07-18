Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945AbaGRQ3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:29:10 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46007 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756009AbaGRQ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:29:06 -0400
Message-ID: <1405700934.605.31.camel@jarvis.lan>
Subject: Re: [PATCH 0/25] Replace DEFINE_PCI_DEVICE_TABLE macro use
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Benoit Taine <benoit.taine@lip6.fr>
Cc: linux-pci@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        ath9k-devel@venema.h4ckr.net, linux-hippi@sunsite.dk,
        dri-devel@lists.freedesktop.org, linux-acenic@sunsite.dk,
        wil6210@qca.qualcomm.com, platform-driver-x86@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-mips@linux-mips.org, users@rt2x00.serialmonkey.com,
        linux-rdma@vger.kernel.org, virtualization@lists.linux-foundation.org,
        industrypack-devel@lists.sourceforge.net, linux-can@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-crypto@vger.kernel.org,
        MPT-FusionLinux.pdl@avagotech.com, devel@linuxdriverproject.org,
        xen-devel@lists.xenproject.org, linux-pcmcia@lists.infradead.org,
        e1000-devel@lists.sourceforge.net
Date: Fri, 18 Jul 2014 09:28:54 -0700
In-Reply-To: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 17:26 +0200, Benoit Taine wrote:
> We should prefer `const struct pci_device_id` over
> `DEFINE_PCI_DEVICE_TABLE` to meet kernel coding style guidelines.
> This issue was reported by checkpatch.

What kernel coding style?  checkpatch isn't the arbiter of style, if
that's the only problem.

The DEFINE_PCI macro was a well reasoned addition when it was added in
2008.  The problem was most people were getting the definition wrong.
When we converted away from CONFIG_HOTPLUG, having this DEFINE_ meant
that only one place needed changing instead of hundreds for PCI tables.

The reason people were getting the PCI table wrong was mostly the init
section specifiers which are now gone, but it has enough underlying
utility (mostly constification) that I don't think we'd want to churn
the kernel hugely to make a change to struct pci_table and then have to
start detecting and fixing misuses.

James


