Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3GAScQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:32:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:17972 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab3GAScO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:32:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,975,1363158000"; 
   d="scan'208";a="338831565"
Date: Mon, 1 Jul 2013 21:36:13 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/6] PCI: acpiphp: do not check for SLOT_ENABLED in
 enable_device()
Message-ID: <20130701183612.GJ9294@intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <4600759.u0rXpSLd62@vostro.rjw.lan>
 <20130701093217.GG9294@intel.com>
 <1530651.ees8hXMYoR@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530651.ees8hXMYoR@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 04:01:37PM +0200, Rafael J. Wysocki wrote:
> > Given the fact that SLOT_ENABLED is only checked in acpiphp_enable_slot()
> > (after this patch) and that /sys/bus/pci/slots/*/power uses SLOT_POWEREDON
> > anyway, should we remove the whole flag?
> 
> Sure, if it is not necessary any more, we should remove it.

Well, there is one thing that changes due that. Once the flag is gone
userspace can do 'echo 1 > /sys/bus/pci/slots/*/power' several times and
the slot is always re-enumerated.

If that is not acceptable we should probably move the SLOT_ENABLED check
closer to acpiphp_core:enable_device() and drop it from here, so that we
always re-enumerate on Bus Check event but userspace can only do enable
once (we still re-enumerate on Bus Check).
