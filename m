Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761000Ab3BJDLY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 22:11:24 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:46977 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab3BJDLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 22:11:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAP9ODKq0jPS9x2LnYc0qTnAB_WeiBDosSohQ-7=uGVDiR0jWtg@mail.gmail.com>
References: <CAP9ODKq0jPS9x2LnYc0qTnAB_WeiBDosSohQ-7=uGVDiR0jWtg@mail.gmail.com>
Date: Sun, 10 Feb 2013 01:11:21 -0200
X-Google-Sender-Auth: cP9uuaeEB1J97uv77tAnf5DDA7g
Message-ID: <CAP9ODKr2gomJR6Zrwc41ddhxn3nkFYtTLL-_xhbdRKN=n-A_+w@mail.gmail.com>
Subject: Re: Linux 3.8 broken for MacBookAir5,1
From: Otavio Salvador <otavio@ossystems.com.br>
To: Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jan 12, 2013 at 8:41 PM, Otavio Salvador
<otavio@ossystems.com.br> wrote:
> Today I tried to update my kernel from 3.7.2 to 3.8-rc3 and I had no
> success; I used localmodconfig to generate the .config for my machine
> but keyboard does not work.
>
> Using same generated .config with 3.7.2 works fine.
>
> Anyone has a clue about?

I finally found time to do a bisect and I found:

commit adfa79d1c06a32650332930ca4c488ca570b3407
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Thu Nov 1 11:13:04 2012 -0400

    USB: EHCI: make ehci-pci a separate driver

    This patch (as1625) splits the PCI portion of ehci-hcd out into its
    own separate driver module, called ehci-pci.  Consistently with the
    current practice, the decision whether to build this module is not
    user-configurable.  If EHCI and PCI are enabled then the module will
    be built, always.

    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    CC: Felipe Balbi <balbi@ti.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

As the problem start.

I do have EHCI and PCI enabled so it should be working. Any clue about
why it breaks it?

--
Otavio Salvador                             O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854              http://projetos.ossystems.com.br
