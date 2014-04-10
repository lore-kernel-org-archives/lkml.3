Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965378AbaDJHNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:13:40 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49683 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965107AbaDJHNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:13:36 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-18-5346449d1cde
Message-id: <1397114014.6717.4.camel@AMDC1943>
Subject: Re: [PATCH] ASoC: core: Fix Sparse incompatible types warning
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Apr 2014 09:13:34 +0200
In-reply-to: <20140410030150.GC18016@ZenIV.linux.org.uk>
References: <1397028108-10976-1-git-send-email-k.kozlowski@samsung.com>
 <5345279F.6070005@metafoo.de> <1397041934.11424.2.camel@AMDC1943>
 <53452F67.3060400@metafoo.de> <20140409202520.GQ6518@sirena.org.uk>
 <5345AD8B.5050306@metafoo.de> <20140410030150.GC18016@ZenIV.linux.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.8.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xK7pzXdyCDS7vNbK4cvEQk8XUh0/Y
	LJZMns9q8e1KB5PF5V1z2Cw6d/WzWrzc/IbJ4vzf46wOHB4bPjexeeycdZfdY9OqTjaPJW8O
	sXrse7uMzWPz6WqPz5vkPDY9ecsUwBHFZZOSmpNZllqkb5fAlfHkkEDBDp6KdUsXMzcwvuTs
	YuTkkBAwkdi+ehMzhC0mceHeerYuRi4OIYGljBLHGuZDOZ8ZJVq/rQOr4hXQk5i97SMTiC0s
	4CYxvXk2WJxNwFhi8/IlbCC2iICqxJ1TZ5hAmpkF3jNKbDq+hhUkwQKU6Pu4hBHE5hSwkHj5
	pJcVYsNcJolzzfPBupkF1CUmzVsEdZOSxLl1axghNgtK/Jh8jwWiRl5i85q3zBMYBWYhaZmF
	pGwWkrIFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MULi4csOxsXHrA4xCnAwKvHwHlzm
	GizEmlhWXJl7iFGCg1lJhFdByC1YiDclsbIqtSg/vqg0J7X4ECMTB6dUA6M/o+qFwB7m/6K3
	326yYDyUbjfbT/aNYL7P/cN9IjO/Fp9IWmvG6BB9qvXWjMbIz/aTpP8cy5z1SVx9Dudqv6kp
	1q81dM/+mGmUuXNedrFW967lTYtvlN8pY7MsSJjMOavigpLk6oaKF387uNK2S2oqLmu49L3T
	3zvDxfTOWqke67dMq2t2MSixFGckGmoxFxUnAgAAgvy0ZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-04-10 at 04:01 +0100, Al Viro wrote:
> On Wed, Apr 09, 2014 at 10:28:59PM +0200, Lars-Peter Clausen wrote:
> 
> > I had a look at the sparse code and the problem is that it sets the
> > default return type of sizeof according to the type of the host it
> > was compiled on (either unsigned int or unsigned long). It can be
> > overwritten by switches like -m32, but of course wont work when
> > cross compiling. So if your host system is 64bit, but your target
> > system is 32bit you'll get that warning.
> 
> Not that simple.  First of all, you *need* to tell sparse what target
> to expect; size_t is the least of your troubles - sizeof(long) has
> far more widespread impact.  If you don't get -m64 or -m32 in CFLAGS
> (and on quite a few cross-builds you get it, simply because the target
> is biarch and gcc itself needs to know what to generate), you need
> to set it in CHECKFLAGS, along with other target-specific things.
> Example:
> arch/ia64/Makefile:21:CHECKFLAGS        += -m64 -D__ia64=1 -D__ia64__=1 -D_LP64 -D__LP64__
> 
> With the defaults being what they are (since commit 7aa79f "Adding default for
> m64/m32 handle"), we probably need explicit -m32 in CHECKFLAGS for a bunch
> of 32bit targets.  Defaults are iffy, BTW - it's not even "do as host does",
> it's "64bit if the host is amd64, 32bit otherwise" ;-/
> 
> Again, CHECKFLAGS need to be set; that's normally done in arch/*/Makefile.

In my case it was cross compile on x86_64 for ARM so adding -m32 to
CHECKFLAGS in arch/arm/Makefile helped.

Best regards,
Krzysztof

