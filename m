Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775Ab3E1QcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:32:14 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:40227 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934675Ab3E1QcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:32:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130528113617.GR14575@console-pimps.org>
References: <1369215782-32697-1-git-send-email-matt@console-pimps.org>
 <CAErSpo4id0RFARD6zCxeMo-uasPBnL7KpUFPqhW4zLgCxrF5fw@mail.gmail.com> <20130528113617.GR14575@console-pimps.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 28 May 2013 10:31:51 -0600
Message-ID: <CAErSpo5DG61wvQEw_9z8vm6Lp=E0urq6LG5SOuWSawkNeDkF+A@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: setup data may be in highmem
To: Matt Fleming <matt@console-pimps.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 5:36 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Fri, 24 May, at 08:38:10AM, Bjorn Helgaas wrote:
>> pcibios_add_device() is mostly called at boot-time, when
>> early_ioremap() probably works well.  But it's also called when we
>> hot-add devices later, and it looks like early_ioremap() will then
>> generate warnings because "system_state != SYSTEM_BOOTING".
>
> Oops. Good point. Is there any reason we can't use ioremap()?

I assume Matthew had some reason for avoiding that in the first place,
so I hope he'll chime in.
