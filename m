Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaCJPVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:21:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63829 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaCJPVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:21:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v6 6/6] pci: Add support for creating a generic host_bridge from device tree
Date: Mon, 10 Mar 2014 16:21:01 +0100
Message-ID: <2115856.ZTdgp5fkma@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140310144414.GT6457@e106497-lin.cambridge.arm.com>
References: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com> <201403081815.08829.arnd@arndb.de> <20140310144414.GT6457@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8pUeofrxQaE99DOZb0FavYkYrar7cIB3LQ6dMsb+l43
 yFlstpcf18piqJ502GWXPa4qwyCudg+aizqJR9vXfWfTcB2CTR
 k8A5IhHAxNSBpnG5OBZxE+k5qMcav50avFDKTfzorYrHU9LH+F
 VKSEgQE/nw5gUIcRW5E+QuIBMD9aDAzQ6PlysRsvivFYt14gMe
 x6lsaodpqgXXjmk/QR4Q3/m5RTTcp6ySPELfH2ucOx9PP7l2CD
 OJzOWKNunSYw9Jsh3HtJ2+JWOBVsYH8gDBg8DLVwx2I960gAJF
 mDaYxl3bkwNopBuezMQfsY+b1PI2NOCZME2SAbJqc0cdiBFaWc
 bigYsMpp+fXth1efMYgA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2014 14:44:14 Liviu Dudau wrote:
> I will try to improve the error handling in the next patchset version.
> However I am still confused about the earlier discussion on
> pci_register_io_range(). Your suggestion initially was to return an
> error in the default weak implementation, but in your last email you
> are talking about returning 'port'.

You can do either one: 'port' should be positive or zero, while the
error would always be negative. We do the same thing in many interfaces
in the kernel.

> My idea when I've introduced the
> helper function was that it would return an error if it fails to
> register the IO range and zero otherwise. I agree that we can treat
> the default 'do nothing with the IO range' case as an error, with
> the caveat that will force architectures that use this code to
> provide their own implementation of pci_register_io_range() in order
> to avoid failure, even for the cases where the architecture has a 1:1
> mapping between IO and CPU addresses.

Which architectures are you thinking of? The only one I know that
does this is ia64, and we won't ever have to support this helper
on that architecture.

I did not ask to treat 'do nothing with the IO range' as an error,
what I meant is that we should treat 'architecture cannot translate
from I/O space to memory space but DT lists a translation anyway'
as an error. On x86, you should never see an entry for the I/O space
in "ranges", so we will not call this function unless there is a
bug in DT.

	Arnd
