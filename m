Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3I0WPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 18:15:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:37590 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab3I0WPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 18:15:32 -0400
Message-ID: <1380320118.27811.48.camel@pasglop>
Subject: Re: Please revert 928bea964827d7824b548c1f8e06eccbbc4d0d7d
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 28 Sep 2013 08:15:18 +1000
In-Reply-To: <CAE9FiQW+b7OtN4hJc6uygzbqzaCOkn3WcLDgSg5isHAJfdgmwg@mail.gmail.com>
References: <1380270519.27811.10.camel@pasglop>
	 <CAE9FiQVkW7d7vFx_kPJG-FEvO71SZjZmpR+dnwVm61wkYK=0YA@mail.gmail.com>
	 <CAE9FiQW+b7OtN4hJc6uygzbqzaCOkn3WcLDgSg5isHAJfdgmwg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 10:44 -0700, Yinghai Lu wrote:
> |        /* Get and check PCI Express port services */
> |        capabilities = get_port_device_capability(dev);
> |        if (!capabilities)
> |                return 0;
> |
> |        pci_set_master(dev);
> 
> so how come that pci_set_master is not called for powerpc?
> 
> Can you send out lspci -vvxxx with current linus-tree and v3.11?

Ah good point. It should have ... except that there are a number of ways
for get_port_device_capability() to fail and that should *not* leave the
bridge without the bus master capability set.

However I don't think that's what's happening here. I'll have to dig
more, will get back to you.

Cheers,
Ben.


