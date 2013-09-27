Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3I0WAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 18:00:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:34665 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab3I0WAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 18:00:18 -0400
Message-ID: <1380319203.27811.44.camel@pasglop>
Subject: Re: Please revert 928bea964827d7824b548c1f8e06eccbbc4d0d7d
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 28 Sep 2013 08:00:03 +1000
In-Reply-To: <CAE9FiQXXvkfTak6oEpUog_RYs_Gwpdji7N5UJ=R11Q61==N97A@mail.gmail.com>
References: <1380270519.27811.10.camel@pasglop>
	 <CAE9FiQVkW7d7vFx_kPJG-FEvO71SZjZmpR+dnwVm61wkYK=0YA@mail.gmail.com>
	 <CA+55aFyDfMdAeaniQwkoeW6F-xd3JxrzGYwtFb6N9+NA6aRCMg@mail.gmail.com>
	 <1380318405.27811.37.camel@pasglop>
	 <CAE9FiQXXvkfTak6oEpUog_RYs_Gwpdji7N5UJ=R11Q61==N97A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 14:54 -0700, Yinghai Lu wrote:
> On Fri, Sep 27, 2013 at 2:46 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> 
> > Wouldn't it be better to simply have pci_enable_device() always set bus
> > master on a bridge? I don't see any case where it makes sense to have
> > an enabled bridge without the master bit set on it...
> 
> Do you mean attached?

That's an option. I was thinking making pci_enable_device() itself
enable bus master on a bridge but yes, you approach should work.

I'm digging a bit more to figure out what went wrong in the
pcie port driver since that's interesting in its own right and I'll then
test your patch which I think is a more robust approach.

Cheers,
Ben.


