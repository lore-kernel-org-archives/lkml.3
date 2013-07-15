Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab3GOWJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:09:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45942 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab3GOWJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:09:44 -0400
Message-ID: <51E472D4.5060307@zytor.com>
Date: Mon, 15 Jul 2013 15:08:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Kyungsik Lee <kyungsik.lee@lge.com>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com> <1367829775-4434-2-git-send-email-kyungsik.lee@lge.com> <20130712075602.GA4002@gmail.com> <20130715150342.35f7620ffe0835e3e2bc37d0@linux-foundation.org>
In-Reply-To: <20130715150342.35f7620ffe0835e3e2bc37d0@linux-foundation.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 03:03 PM, Andrew Morton wrote:
> 
> I don't know how to do this.  Any suggestions?
> 
> It has to be done at `make config' time.  We'd need to probe for the
> presence of lz4c and then....  what?
> 
> Is there any precedent for this?
> 
> I don't think we can just ignore the absence of lz4c - the user has
> selected a config which his system cannot build.  The problem lies
> within randconfig itself.
> 

We keep running over the need to be able to have kconfig run tests on
the build system (for toolchain support or for optional tools needed);
running them in the Makefiles (i.e. at Kbuild time) is simply too late.

	-hpa

