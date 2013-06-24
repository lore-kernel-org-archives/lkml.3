Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157Ab3FXInA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:43:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab3FXIm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:42:59 -0400
Message-ID: <51C80691.9030106@suse.cz>
Date: Mon, 24 Jun 2013 10:42:57 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
Subject: Re: [PATCH 12/14] kconfig: sort found symbols by relevance
References: <cover.1371595499.git.yann.morin.1998@free.fr>  <3e2346029e33ef9405b87d72a32d96d0aafb524a.1371595499.git.yann.morin.1998@free.fr> <1372060659.4310.41.camel@chaos.site>
In-Reply-To: <1372060659.4310.41.camel@chaos.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.6.2013 09:57, Jean Delvare wrote:
> Hi Yann,
> 
> Sorry for the late reply...
> 
> Le Wednesday 19 June 2013 à 00:45 +0200, Yann E. MORIN a écrit :
>> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
>>
>> When searching for symbols, return the symbols sorted by relevance.
>>
>> Sorting is done as thus:
>>   - first, symbols with a prompt,   [1]
>>   - then, smallest offset,          [2]
>>   - then, shortest match,           [3]
>>   - then, highest relative match,   [4]
>>   - finally, alphabetical sort      [5]
>>
>> So, searching (eg.) for 'P.*CI' :
> 
> Nobody would actually search for that, so that's not a particularly good
> example to determine whether your sort order is sane or not.
> 
>>
>> [1] Symbols of interest are probably those with a prompt, as they can be
>>     changed, while symbols with no prompt are only for info. Thus:
>>         PCIEASPM comes before PCI_ATS
> 
> This is not necessarily true. I often look for symbols which have no
> prompt, and the information I am looking for is exactly "does this
> symbol have a prompt or is its value determined automatically"?
> 
>> [2] Symbols that match earlier in the name are to be preferred over
>>     symbols which match later. Thus:
>>         PCI_MSI comes before WDTPCI
> 
> This makes some sense, although it could have some unexpected side
> effects (e.g. FOO_BAR_PCI would be listed before SOMETHING_PCI_BAZBAZ,
> right?)
> 
>> [3] The shortest match is (IMHO) more interesting than a longer one.
>>     Thus:
>>         PCI comes before PCMCIA
> 
> This makes sense too, but I'm sure there are cases where it will be
> confusing too, and alphabetical order would do it in part too.

PCI does sort before PCMCIA alphabetically ;). Also, the match lenght
will only be different when using regular expressions, so this rule will
not matter in the usual case.


>> [4] The relative match is the ratio of the length of the match against
>>     the length of the symbol. The more of a symbol name we match, the
>>     more instersting that symbol is. Thus:
>>         PCIEAER comes before PCIEASPM
> 
> This is an obscure sort rule and I'm sure it will add more confusion
> than it will help. Alphabetical order should really be good enough at
> this point.

When the prefix matches, then I agree that most people will expect the
matches be alphabetically sorted. Maybe only do this comparison only if
s1->so != 0, otherwise fallback to the strcmp() directly?

Thanks,
Michal
