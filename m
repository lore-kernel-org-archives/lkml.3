Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936310Ab3DQRaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:30:15 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:63323 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935915Ab3DQRaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:30:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7nj3DQ-RB0UJdkzfN0L891xiTH8yzzcv7pW4AZ6waJ2A@mail.gmail.com>
References: <1366196798-15929-1-git-send-email-artem.savkov@gmail.com>
	<CAErSpo6uAbiJ5GtvOmoABvwSnWj3DRRrXB6K1PzQSnReFqbqxA@mail.gmail.com>
	<CAErSpo7nj3DQ-RB0UJdkzfN0L891xiTH8yzzcv7pW4AZ6waJ2A@mail.gmail.com>
Date: Wed, 17 Apr 2013 10:30:12 -0700
X-Google-Sender-Auth: KtZsEUxrK58u-aYriN6P-jmLsc0
Message-ID: <CAE9FiQWBXHgz-gWCmpWLaBOfQQJwtRZemV6Ut9GVw_KJ-dTGTA@mail.gmail.com>
Subject: Re: [PATCH] PCI: pci_bus_add_device() should succeed even if creating
 sysfs files fails
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Artem Savkov <artem.savkov@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 9:42 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> It would be ideal if we could get rid of the pci_sysfs_init()
> late_initcall and just make the pci_create_sysfs_dev_files() from
> pci_bus_add_device() work all the time, even at boot-time.  I didn't
> look hard enough to figure out why this needs to be a late_initcall.

have to call that after pci assign unassigned resource.
