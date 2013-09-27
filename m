Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3I0VrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 17:47:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:41270 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab3I0VrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 17:47:04 -0400
Message-ID: <1380318405.27811.37.camel@pasglop>
Subject: Re: Please revert 928bea964827d7824b548c1f8e06eccbbc4d0d7d
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 28 Sep 2013 07:46:45 +1000
In-Reply-To: <CA+55aFyDfMdAeaniQwkoeW6F-xd3JxrzGYwtFb6N9+NA6aRCMg@mail.gmail.com>
References: <1380270519.27811.10.camel@pasglop>
	 <CAE9FiQVkW7d7vFx_kPJG-FEvO71SZjZmpR+dnwVm61wkYK=0YA@mail.gmail.com>
	 <CA+55aFyDfMdAeaniQwkoeW6F-xd3JxrzGYwtFb6N9+NA6aRCMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 10:10 -0700, Linus Torvalds wrote:
> > So i would like to use the first way that you suggest : call pci_set_master
> > PCIe port driver.
> 
> So I have to say, that if we can fix this with just adding a single
> new pci_set_master() call, we should do that before we decide to
> revert.
> 
> If other, bigger issues then come up, we can decide to revert. But if
> there's a one-liner fix, let's just do that first, ok?
> 
> Mind sending a patch?

Wouldn't it be better to simply have pci_enable_device() always set bus
master on a bridge? I don't see any case where it makes sense to have
an enabled bridge without the master bit set on it...

Cheers,
Ben.


