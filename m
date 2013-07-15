Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab3GOWhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:37:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46157 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823Ab3GOWhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:37:02 -0400
Message-ID: <51E47924.9030005@zytor.com>
Date: Mon, 15 Jul 2013 15:35:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Chen Gang <gang.chen@asianux.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH, re-send] Always trap on BUG()
References: <201307051738.35930.arnd@arndb.de> <20130715151612.9499c2b2ad40e88d183a4600@linux-foundation.org> <20130715222755.GY24642@n2100.arm.linux.org.uk>
In-Reply-To: <20130715222755.GY24642@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 03:27 PM, Russell King - ARM Linux wrote:
> On Mon, Jul 15, 2013 at 03:16:12PM -0700, Andrew Morton wrote:
>> I've been thinking for a while that CONFIG_BUG=n is a pretty dumb thing
>> to do, and that maintaining it (and trying to fix the warnings it
>> produces) aren't worth the effort and that we should remove the whole
>> thing.  Perhaps your patch changes that calculus, dunno.  Please discuss.
> 
> This isn't about introducing "CONFIG_BUG=n" - this is about making a
> kernel with CONFIG_BUG=n build without producing tonnes and tonnes of
> warnings, as it does today.  It makes building randconfig pretty
> useless to find what could be more important warnings.
> 

Well, there are three alternatives here, right:

1. We can use unreachable(), which means that the compiler can assume it
never happens.

2. We can trap without metadata.

3. We can trap with metadata (current CONFIG_BUG=y).

I am *guessing* this does 2, but it isn't clear.

	-hpa


