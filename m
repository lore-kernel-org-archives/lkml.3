Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3CFVXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 16:23:30 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:33603 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3CFVX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 16:23:29 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: Final versions of ncurses libs detection patches
Date: Wed, 6 Mar 2013 22:23:24 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.2-treguer; KDE/4.4.5; x86_64; ; )
Cc: jlec@gentoo.org, linux-kernel@vger.kernel.org
References: <Use config scripts to detect ncurses libs for, menuconfig/nconfig dialogs> <1362574922-4799-1-git-send-email-jlec@gentoo.org>
In-Reply-To: <1362574922-4799-1-git-send-email-jlec@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303062223.24541.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin, All,

On Wednesday 06 March 2013 jlec@gentoo.org wrote:
> I am sorry for the long delay.
> Final versions of the patches which are reduced to the usage of pkg-config. And
> if unavailable we use the old code.

On Ubuntu Quantal, ncurses is indeed compiled with tinfo as a separate
lib, but these two patches are not needed, because libncurses has proper
(NEEDED) on libtinfo:

  $ readelf -d /lib/x86_64-linux-gnu/libncurses.so.5.9 |grep tinfo
  0x0000000000000001 (NEEDED)             Shared library: [libtinfo.so.5]

If I just configure ncurses with:
  $ ./configure --with-termlib --with-shared --without-normal && make
  $ readelf -d lib/libncurses.so.5.9 |grep tinfo
  0x0000000000000001 (NEEDED)             Shared library: [libtinfo.so.5]

I wonder how you configured your ncurses.

But anyway, even in that cse, using pkg-config when available is better
than using our previous legacy checks.

I'm still doing a few more tests on my side before queuing.

> Thanks for all suggestions,

Thanks for staying around during the iterations.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
