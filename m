Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab3E1LgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 07:36:22 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48629 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932878Ab3E1LgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 07:36:20 -0400
Date: Tue, 28 May 2013 12:36:17 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/PCI: setup data may be in highmem
Message-ID: <20130528113617.GR14575@console-pimps.org>
References: <1369215782-32697-1-git-send-email-matt@console-pimps.org>
 <CAErSpo4id0RFARD6zCxeMo-uasPBnL7KpUFPqhW4zLgCxrF5fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4id0RFARD6zCxeMo-uasPBnL7KpUFPqhW4zLgCxrF5fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May, at 08:38:10AM, Bjorn Helgaas wrote:
> pcibios_add_device() is mostly called at boot-time, when
> early_ioremap() probably works well.  But it's also called when we
> hot-add devices later, and it looks like early_ioremap() will then
> generate warnings because "system_state != SYSTEM_BOOTING".

Oops. Good point. Is there any reason we can't use ioremap()?

-- 
Matt Fleming, Intel Open Source Technology Center
