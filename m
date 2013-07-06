Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3GFA3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 20:29:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:38581 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab3GFA3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 20:29:43 -0400
Message-ID: <1373070567.4446.14.camel@pasglop>
Subject: Re: [PATCH] pci: Avoid unnecessary calls to work_on_cpu
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 06 Jul 2013 10:29:27 +1000
In-Reply-To: <CAErSpo70VKFxJqyZJKSp=CZ2x131Kz_+0vah3juTEuEx5RLX8A@mail.gmail.com>
References: <20130624195942.40795.27292.stgit@ahduyck-cp1.jf.intel.com>
	 <CAErSpo70VKFxJqyZJKSp=CZ2x131Kz_+0vah3juTEuEx5RLX8A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-05 at 17:36 -0600, Bjorn Helgaas wrote:
> It seems a little strange to me that this "run the driver probe method
> on the correct node" code is in PCI.  I would think this behavior
> would be desirable for *all* bus types, not just PCI, so maybe it
> would make sense to do this up in device_attach() or somewhere
> similar.
> 
> But Rusty added this (in 873392ca51), and he knows way more about this
> stuff than I do.

I tend to agree... I can see this being useful on some of our non-PCI
devices on power as well in fact.

Cheers,
Ben.


