Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaCKGvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:51:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:50037 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaCKGvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:51:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Liviu Dudau <liviu@dudau.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Tanmay Inamdar <tinamdar@apm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v6 6/6] pci: Add support for creating a generic host_bridge from device tree
Date: Tue, 11 Mar 2014 07:50:24 +0100
Message-ID: <4254618.BlpDUOctDb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140310215600.GA14968@bart.dudau.co.uk>
References: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com> <1469359.kil5iaOqdU@wuerfel> <20140310215600.GA14968@bart.dudau.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Zkvk8EkEPe7erKKfVfEKjMAgTveLO+sw3Uy7PP5yMOS
 5GtBqRoJsE0wTghJd07voFrBssu2rnGXAeET4gdNf83MeSQH9e
 GWWA5szW54FJA90/1R5MJ1GGmeKCYJ4QPovlQIDCwx9n31FDIH
 yPXKD82hqAsr+sKrzDilhQyJtrmE2QudGgqKPwx4DOnLFQPklE
 18dbzP5Fb0mkbv5X/cobisNG+mKwSV+1fEA6EE0O5pP8ZkOCJZ
 YpATTVTF8XVR8a140bJ4uXuPwYlWjqEEqL6Jr9LJpDVkKHjtmj
 4gV9/h+WUO7yOxGztvz0mCyRQ7jh6IhqFRJjyWk9c/WOfOnVv4
 AIB8e8GgdXkQquPnvfCs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2014 21:56:00 Liviu Dudau wrote:
> 
> PCI_IOBASE is always defined. See the discussion with Russell on this subject.
> 
> include/asm-generic/io.h has at line 118:
> 
> #ifndef PCI_IOBASE
> #define PCI_IOBASE ((void __iomem *) 0)
> #endif

That is only defined for those that use asm-generic/pci.h, which most architectures
don't.
 
> I will go with my idea tomorrow. arm64 overwrite the implementation anyway, I
> find it cleaner rather than having to do #ifdefs and/or ifs.

I'd really hope we can get to a point where arm64 doesn't need any architecture
specific code for this. It doesn't do anything special.

	Arnd
