Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3FYVrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:47:12 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45294 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3FYVrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:47:10 -0400
MIME-Version: 1.0
In-Reply-To: <1372196295.3944.221.camel@pasglop>
References: <1370066593-22736-1-git-send-email-yinghai@kernel.org>
 <1370066593-22736-3-git-send-email-yinghai@kernel.org> <20130625211516.GA8494@google.com>
 <1372196295.3944.221.camel@pasglop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 25 Jun 2013 15:46:49 -0600
Message-ID: <CAErSpo7b7=E8uG-TzcNinE1F9QUX2xyC-WFGXKVv5svcrZ9aGQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] PCI: Use pci_walk_bus to detect unassigned resources
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Gavin Shan <shangw@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 3:38 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Tue, 2013-06-25 at 15:15 -0600, Bjorn Helgaas wrote:
>> -     for_each_pci_dev(dev) {
>> > -             int i;
>> > +             /* Not assigned, or rejected by kernel ? */
>> > +             if (r->flags && !r->start) {
>> > +                     (*unassigned)++;
>> > +                     return 1; /* return early from pci_walk_bus */
>> > +             }
>> > +     }
>
> BTW. I'm aware you didn't change that logic but ... it's somewhat broken
> in the case where the aperture has an offset. You should compare
> r->start with the offset, not with 0.

Yes, please fix that in a separate patch that contains only the bugfix.
