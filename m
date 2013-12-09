Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555Ab3LIVHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:07:23 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34811 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3LIVHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:07:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQW60hW06sr=ahV6rEMRQ5kA04A_1mUtfZQAra__6ttNxw@mail.gmail.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
 <1386546869-31900-2-git-send-email-yinghai@kernel.org> <CAErSpo7HaAbsoy0n5sr_d3iPazEnpnO8WupJrDn2QR2Kid=EgQ@mail.gmail.com>
 <CAE9FiQUebPPcTyHGssxTwJJ3GYx4aq-=infapvxOQgAm+PL4rA@mail.gmail.com>
 <CAE9FiQUrTAnQkiS9SU3-pJ35-U9CqXQNQEceUUarf-WiPXCF2Q@mail.gmail.com>
 <20131209204323.GA25180@kroah.com> <CAE9FiQW60hW06sr=ahV6rEMRQ5kA04A_1mUtfZQAra__6ttNxw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 9 Dec 2013 14:06:59 -0700
Message-ID: <CAErSpo7DPMRBHefLXSvw8v=vdu_qzGDKbbjXtZSF61cA1_padw@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: pcibus address to resource converting take bus
 instead of dev
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 1:47 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Dec 9, 2013 at 12:43 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Mon, Dec 09, 2013 at 12:03:18PM -0800, Yinghai Lu wrote:
>>> On Mon, Dec 9, 2013 at 11:21 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> > On Mon, Dec 9, 2013 at 9:52 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> >>
>>> >> Ugh.  Why would we add new functions with "__" prefixes?  There are
>>> >> only a handful of callers to pcibios_bus_to_resource() and
>>> >> pcibios_resource_to_bus().  We can just change them to supply a
>>> >> "struct pci_bus *" directly.  That's a better match for how the
>>> >> hardware works anyway.
>>> >
>>>
>>> Please double check if you are happy with the change.
>>> Hope that will not update stable tree maintainer guys.
>>
>> What do you mean by this?
>
> Do not want to change too much code, to upset stable tree maintainers.
>
>>
>> How is this a -stable kernel patch?
>
> We have stable patch that will need use the new function.
>
> [PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit mmio

Let's not get too far ahead of ourselves here.  I don't like this
patch even for upstream, so we don't need to worry about -stable quite
yet.

Bjorn
