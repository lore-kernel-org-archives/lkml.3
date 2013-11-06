Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab3KFRRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:17:46 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:38619 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab3KFRRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:17:44 -0500
Message-ID: <527A79B5.4070507@gmail.com>
Date: Wed, 06 Nov 2013 11:17:41 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Robert Richter <rric@kernel.org>, linux-edac@vger.kernel.org
Subject: Re: [PATCH] edac, highbank: remove dependency on ARCH_HIGHBANK
References: <1383708352-19527-1-git-send-email-robherring2@gmail.com> <20131106142025.GB16072@x1.alien8.de> <527A6B08.5020302@gmail.com> <20131106165437.GA21870@x1.alien8.de>
In-Reply-To: <20131106165437.GA21870@x1.alien8.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 10:54 AM, Borislav Petkov wrote:
> On Wed, Nov 06, 2013 at 10:15:04AM -0600, Rob Herring wrote:
>> Other maintainers disagree because it reduces build coverage.
> 
> What possible build coverage are we talking about when building highbank
> on x86, for example? And what does a build failure in that configuration
> tell you if it builds and boots fine on your hardware?

Using some interface which is arch specific and should not be used in a
driver. We used to have tons of mach dependencies in "ARM" drivers that
took a lot of effort to clean-up. Requiring all drivers to build on
allyesconfigs would have prevented that. The same thing applies at the
architecture level. Of course there are exceptions, but if we only limit
the exceptions then they are easy to find.

>> Having done some cross arch clean-up, I have to agree with that
>> position. Iterating builds over different arches is bad enough, but
>> iterating over all configs for each arch is a pain.
> 
> So make highbank depend only on the arches for which it is supposed to
> work but not for *all* arches. Look at how the other edac drivers do it,
> x86 ones depend on X86, tile on tile, etc, etc. Why should highbank be
> special?
> 
>> It would be nice to have a uniform policy here.
> 
> Simple: drivers should be selectable/buildable only on the arches
> they're supposed to run on.

Like I said, not all maintainers agree. David M rejected patches from me
restricting our network driver to ARM.

Rob

