Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaKGMLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:11:44 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:58937 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751435AbaKGMLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:11:40 -0500
Date: Fri, 7 Nov 2014 12:11:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Message-ID: <20141107121119.GQ4042@n2100.arm.linux.org.uk>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org>
 <1977974.l97vvy7Y8b@wuerfel>
 <20141107115551.GC18916@arm.com>
 <1678531.AUssrM9PAs@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1678531.AUssrM9PAs@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 01:03:00PM +0100, Arnd Bergmann wrote:
> On Friday 07 November 2014 11:55:51 Will Deacon wrote:
> > We need this for arm64 and, since all architectures seem to have a mechanism
> > for setting a system call via ptrace, moving it to generic code should make
> > sense for new architectures too, no?
> 
> It makes a little more sense now, but I still don't understand why you
> need to set the system call number via ptrace. What is this used for,
> and why doesn't any other architecture have this?

All other architectures have a way.  x86, for example, you set orig_eax
(or orig_rax) to change the syscall number.  On ARM, that doesn't work
because we don't always pass the syscall number in a register.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
