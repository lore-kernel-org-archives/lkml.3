Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3LQV6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 16:58:03 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48274 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3LQV6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 16:58:00 -0500
MIME-Version: 1.0
In-Reply-To: <1387312137.30327.11.camel@bling.home>
References: <20131210183339.26294.14581.stgit@bling.home> <20131210184845.26294.81385.stgit@bling.home>
 <20131217180322.GA12482@google.com> <1387312137.30327.11.camel@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 17 Dec 2013 14:57:39 -0700
Message-ID: <CAErSpo653fTtNkMk9gNkXsCVgFuVPnJmhFw5rO6ytefbDSSEyA@mail.gmail.com>
Subject: Re: [PATCH 3/3] pci: Add Virtual Channel to save/restore support
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 1:28 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Tue, 2013-12-17 at 11:03 -0700, Bjorn Helgaas wrote:
>> On Tue, Dec 10, 2013 at 11:48:45AM -0700, Alex Williamson wrote:
>> >...
>> > +   pci_read_config_dword(dev->bus->self, pos2 + PCI_VC_PORT_REG1, &reg1);
>> > +   evcc = reg1 & PCI_VC_REG1_EVCC;
>>
>> I think PCI_VC_PORT_REG1 and PCI_VC_PORT_REG2 are mis-named and should be
>> changed to CAP1 and CAP2 or similar.  Almost everything here is a
>> "register."
>
> That's true, but it matches the name in the spec: "Port VC Capability
> Register 1/2".  Thanks,

Sure, but we use PCI_EXP_DEVCAP for the "Device Capabilities
Register," PCI_EXP_DEVCTL for the "Device Control Register," etc.  All
I'm saying is that "REG" doesn't convey as much information as "CAP."

Bjorn
