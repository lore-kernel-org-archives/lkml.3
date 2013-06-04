Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab3FDOiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:38:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58482 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3FDOiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:38:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, resend] pch_phub: re-use native MAC address parser
Date: Tue, 04 Jun 2013 16:38:11 +0200
Message-ID: <3489856.nvZgTyoe0K@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CAHp75VdrXdA7uwpYoo5To-niMn8wSCdwu_p6fArq+Vd6kb-0EA@mail.gmail.com>
References: <1369756498-5670-1-git-send-email-andriy.shevchenko@linux.intel.com> <201306041603.15653.arnd@arndb.de> <CAHp75VdrXdA7uwpYoo5To-niMn8wSCdwu_p6fArq+Vd6kb-0EA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5CkE5ybGDDXpmfQqzda6IajFHnzenXDNXrR5zenENTV
 1xb6WnvclW4bySy5DUmN6wJevDWKvkBNmFQce9gMxZuC7w6igc
 AHPQvcwIf7Y0sy806yxQXNmmKV1G2Np5zBM0sf+nnSrb2TJjHA
 rPTY+FG37LNVLTkNpJuc3VMbukqrnRoxXVf4NCfPcL/+gluaN0
 xdwErzZ6zu9RUVzYLyZ+Ht8gjf65nnjwoS2pdDBZIbFvWbKbsG
 9GIE/xiu2HmzlgUUTUdHQGCa2ZyrhOkHpnKo0kIC1wncdBEpgy
 PjX9gBscePbinaj4V+pZawqvWQgirWOsxZzt4KULNIfBkBSV4l
 PS7Szgs/Hmvuh+bxCUng=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 17:21:16 Andy Shevchenko wrote:

> > The easiest solution would be to
> > make the entire driver "depend on NET".
> 
> I don't feel that is good idea. Driver is an abstraction to the ROM,
> it doesn't mean you can't read ROM without network framework.

Right, makes sense.

> It seems proper solution is to move mac_pton() outside of CONFIG_NET,
> though I don't know how to do this easily.

If we want to use it outside of CONFIG_NET, it cannot be part of net/core/*.c.
Maybe we can move the function to lib/mac_pton.c instead and create a
Kconfig symbol that gets selected by CONFIG_NET and by any driver lib
PCH_PHUB that needs it.

	Arnd
