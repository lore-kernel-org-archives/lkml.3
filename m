Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab3EWKgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:36:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102Ab3EWKgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:36:22 -0400
Message-ID: <519DF122.5020802@suse.cz>
Date: Thu, 23 May 2013 12:36:18 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: Blocking allmodconfig with missing defaults (was: Re: kbuild:
 Fix missing '\n' for NEW symbols in yes "" | make oldconfig >conf.new)
References: <CAMuHMdXAGBU97pg2SzoZteFk9fd7FOpOVtu=buZ40z+SwRpE6Q@mail.gmail.com>
In-Reply-To: <CAMuHMdXAGBU97pg2SzoZteFk9fd7FOpOVtu=buZ40z+SwRpE6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.5.2013 11:52, Geert Uytterhoeven wrote:
> On Wed, Feb 27, 2013 at 9:37 PM, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>> Gitweb:     http://git.kernel.org/linus/;a=commit;h=62dc989921df2a98d1a73aacd085abe941cb9828
>>
>>     According to Documentation/kbuild/kconfig.txt, the commands:
>>
>>         yes "" | make oldconfig >conf.new
>>         grep "(NEW)" conf.new
>>
>>     should list the new config symbols with their default values.
> 
> There are other cases where this is not working.
> If there are int or hex symbols without a default value, "allmodconfig",
> "allyesconfig", "allnoconfig", and "randconfig" fill in empty string values,
> causing a subsequent build (which does oldconfig) to wait for user input.
> 
> This is easy to reproduce:
>     make ARCH=h8300 allmodconfig
>     make ARCH=h8300 oldconfig
> 
> Should kconfig generate default values for these cases?

Yes, I think that we should generate a default of 0 / 0x0 or the lower
bound of the range, if specified.

Michal
