Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab3FYU6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:58:43 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64043 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3FYU6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:58:41 -0400
Date: Tue, 25 Jun 2013 22:58:36 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sedat Dilek <sedat.dilek@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>
Subject: Re: [PATCH 15/15] kconfig: fix randomising choice entries in
 presence of KCONFIG_ALLCONFIG
Message-ID: <20130625205836.GB14074@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
 <8357b48549e17b3e4e402c7f977b65708922e60f.1372097219.git.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8357b48549e17b3e4e402c7f977b65708922e60f.1372097219.git.yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On 2013-06-24 20:11 +0200, Yann E. MORIN spake thusly:
> Currently, randconfig does randomise choice entries, unless KCONFIG_ALLCONFIG
> is specified.
[--SNIP--]
> This patch defers setting that a choice has a value until a symbol for
> that choice is indeed set, so that choices are properly randomised when
> KCONFIG_ALLCONFIG is set, but not if a symbol for that choice is set.

OK, so this second attempt also broke standard workflows. Fixing it is
more involved than expected. Let's get rid of it before too many people
complain, and before it hits mainline.

Michal, can you strip this from your tree (since it's the HEAD of your
kconfig branch), or do you want me to submit a revert patch?

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
