Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbbAWNJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:09:01 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:48328 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbbAWNJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:09:00 -0500
Date: Fri, 23 Jan 2015 13:08:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>, spear-devel@list.st.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v12 00/15] arm: Fix DEBUG_LL for multi-platform kernels
 (without PL01X)
Message-ID: <20150123130837.GE26493@n2100.arm.linux.org.uk>
References: <1414148076-12685-1-git-send-email-daniel.thompson@linaro.org>
 <1822066.pI6QN22RDx@wuerfel>
 <CAMuHMdUpNtL+K28DdC8xJ3vUPZGmviWcYGOVUNuhKQoobdL00Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUpNtL+K28DdC8xJ3vUPZGmviWcYGOVUNuhKQoobdL00Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 02:05:22PM +0100, Geert Uytterhoeven wrote:
> Hi Arnd,
> 
> On Fri, Oct 24, 2014 at 5:46 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > There is still a related bug that we should also fix, but I'd say let's
> > take your current patches first and then add whatever is missing
> > on top. Specifically, a snippet like this
> >
> >         default 0xd4017000 if DEBUG_MMP_UART2
> >         default 0xd4018000 if DEBUG_MMP_UART3
> >         default 0xe0000000 if ARCH_SPEAR13XX
> >         default 0xe4007000 if DEBUG_HIP04_UART
> >         default 0xf0000be0 if ARCH_EBSA110
> >
> > still means you get the wrong default when you build a multiplatform
> > kernel that you want to boot on HIP04 and you set DEBUG_HIP04_UART
> > but you happen to also have ARCH_SPEAR13XX enabled.
> >
> > I have a patch that I use locally for randconfig builds that tries
> > to fix this. It has some overlaps with your work but most parts are
> > distinct. See below.
> 
> This is still desperately needed for anyone who wants to enable DEBUG_LL
> on other platforms using multi_v7_defconfig.

I'd actually prefer to kill all these defaults and let people enter the
value they want - for exactly this reason.

However, I realise that would not be popular, because removing them
means that people have to refer to some kind of documentation to find
the correct value, and that's hassle.

So, the existing defaulting behaviour is my compromise, but as I say,
I'd much prefer the unpopular move of killing the entire set of defaults.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
