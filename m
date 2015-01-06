Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbbAFEEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 23:04:33 -0500
Received: from one.firstfloor.org ([193.170.194.197]:55432 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbbAFEEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 23:04:30 -0500
Date: Tue, 6 Jan 2015 05:04:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API
 to arch_prctl
Message-ID: <20150106040428.GR2915@two.firstfloor.org>
References: <cover.1419900414.git.luto@amacapital.net>
 <d5efe02b133f6d9fb4cb9d03e0f0b9e17211c06f.1419900414.git.luto@amacapital.net>
 <54A64E6D.1020304@linux.intel.com>
 <87mw5x0xjz.fsf@tassilo.jf.intel.com>
 <54AAFFA3.6000901@linux.intel.com>
 <CALCETrUeMS7zwjXfSMN-6A8-gpLc68n7U5Y6SPdzgw6hSbYGNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUeMS7zwjXfSMN-6A8-gpLc68n7U5Y6SPdzgw6hSbYGNg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We should avoid arch_prctl because glibc won't add a syscall stub that
> libgcc or whatever would want?  My mind boggles.

Please turn brain on before posting.

Of course they would add it. But only in the next version. Which means
everyone using older glibc would be out of luck. So all the users
would be stuck using syscall(). Anything you may gain in the kernel
would be totally made up by that.

BTW I added arch_prctl, but in hindsight it wasn't good idea.

-Andi
