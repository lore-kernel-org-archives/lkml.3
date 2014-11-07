Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaKGObT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:31:19 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:49971 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaKGObR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:31:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Date: Fri, 07 Nov 2014 15:30:52 +0100
Message-ID: <6654405.Rf26mgoaDJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141107131129.GF18916@arm.com>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org> <353850534.aGkkrtTogX@wuerfel> <20141107131129.GF18916@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:p3crSdUvxWxdrb649nMPZmRB50Djkmn5o4z4cy8FCFd
 xWu6AvoOa/qicTJkuGJAaben1yF5X4Ke+aN+jWEb1OxsP1gjlf
 JvLKnoCyZaHpe8ciNikR0ZcdHhNVgSxuYXdwr7d18h5D2Ud6P8
 RFPKXsFxKVVqftQ2H1RDotewyCkNxaZyUvjBvu0lqHK8E7QpLP
 ndA85bl2/qyr1zTSmI4GS1fZX47tzV+fdWpmdbHJ595uB+pxak
 LTZFFNW4g3JNVG9ji3GSpkYqyO3udEyzK8ealh0o2B65wUwal/
 5HGqMZWzyNCUmrMra36sg9gf9B/Y/6s0GZXd0z8ZFW4sYhLXqE
 zyZxJI0pfTzn+5oYF88w=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2014 13:11:30 Will Deacon wrote:
> 
> > It's not that I care strongly about the interface, my main point is
> > that the changelog doesn't describe why one interface was used instead
> > the other.
> 
> I suspect the current approach was taken because it follows the same scheme
> as 32-bit ARM. If both methods are sufficient (Kees would have a better idea
> than me on that), then I don't have a strong preference.

Using the regset would probably address Oleg's comment, and would keep the
implementation architecture specific. You could even share the NT_S390_SYSTEM_CALL
number, but I don't know if there any downsides to doing that.

	Arnd
