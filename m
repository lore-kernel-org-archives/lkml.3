Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaHMSoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:44:54 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:61713 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaHMSow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:44:52 -0400
Date: Wed, 13 Aug 2014 19:44:49 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org
Subject: Re: Loading initrd above 4G causes freeze on boot
Message-ID: <20140813184449.GV15082@console-pimps.org>
References: <53E62EEF.9040801@gmail.com>
 <CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
 <20140809192302.GJ15082@console-pimps.org>
 <CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
 <CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
 <CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
 <20140813140219.GP15082@console-pimps.org>
 <CAPWNY8WdA+Q+WjXirGOsrYjMGp+69sCqYa8ST7_owQeVhQkT0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPWNY8WdA+Q+WjXirGOsrYjMGp+69sCqYa8ST7_owQeVhQkT0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug, at 07:38:14PM, Mantas Mikulėnas wrote:
> 
> Here you go.
> 
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000137ffffff] usable

[...]

> [    0.000000] reserve setup_data: [mem 0x0000000100000000-0x0000000137ffffff] usable

[...]

> [    0.000000] efi: mem201: type=7, attr=0xf, range=[0x0000000100000000-0x0000000138000000) (896MB)

Nothing crazy here, unless we're getting the calculation wrong and
reading past the buffer, the code looks OK though. Or something like the
last page or so of that memory isn't actually free even though the
firmware tells us it is.

At this point, I think modifying the max address is the best way to
debug this further, and figure out what address causes the hang.

-- 
Matt Fleming, Intel Open Source Technology Center
