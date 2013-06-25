Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab3FYVi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:38:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:54436 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3FYVi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:38:26 -0400
Message-ID: <1372196295.3944.221.camel@pasglop>
Subject: Re: [PATCH v5 3/7] PCI: Use pci_walk_bus to detect unassigned
 resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Gavin Shan <shangw@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 26 Jun 2013 07:38:15 +1000
In-Reply-To: <20130625211516.GA8494@google.com>
References: <1370066593-22736-1-git-send-email-yinghai@kernel.org>
	 <1370066593-22736-3-git-send-email-yinghai@kernel.org>
	 <20130625211516.GA8494@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 15:15 -0600, Bjorn Helgaas wrote:
> -     for_each_pci_dev(dev) {
> > -             int i;
> > +             /* Not assigned, or rejected by kernel ? */
> > +             if (r->flags && !r->start) {
> > +                     (*unassigned)++;
> > +                     return 1; /* return early from pci_walk_bus */
> > +             }
> > +     }

BTW. I'm aware you didn't change that logic but ... it's somewhat broken
in the case where the aperture has an offset. You should compare
r->start with the offset, not with 0.

Cheers,
Ben.


