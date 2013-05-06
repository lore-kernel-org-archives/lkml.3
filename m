Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab3EFP3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:29:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab3EFP3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:29:38 -0400
Subject: Re: [PATCH] kconfig: sort found symbols by relevance
From: Jean Delvare <jdelvare@suse.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
In-Reply-To: <1367845365-13316-1-git-send-email-yann.morin.1998@free.fr>
References: <1367826629.4494.30.camel@chaos.site>
	 <1367845365-13316-1-git-send-email-yann.morin.1998@free.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 06 May 2013 17:28:32 +0200
Message-ID: <1367854112.4569.137.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Monday 06 May 2013 à 15:02 +0200, Yann E. MORIN a écrit :
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> When searching for symbols, return the symbols sorted by relevance.
> 
> Relevance is the ratio of the length of the matched string and the
> length of the symbol name. Symbols of equal relevance are sorted
> alphabetically.
> 
> Reported-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Cc: Jean Delvare <jdelvare@suse.de>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Roland Eggner <edvx1@systemanalysen.net>
> Cc: Wang YanQing <udknight@gmail.com>
> ---
>  scripts/kconfig/symbol.c | 66 +++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 57 insertions(+), 9 deletions(-)

I did not look at the code, only tested it, and it does what I asked for
originally: exact match is listed first. So thank you :)

However I am not sure if your implementation is what we want. Your
definition of "relevance" is somewhat arbitrary and may not be
immediately to others. For example, my own definition of "relevance" was
that symbols which start with the subject string are more relevant than
the symbols which have the string in the middle. Others would possibly
have other definitions.

So in the end you have somewhat complex code for a sort order which may
surprise or confuse the user. It may put close to each other options
which are completely unrelated, and suboptions very far from their
parent.

I am wondering if it might not be better to go for a more simple
strategy: exact match on top and then sort alphabetically. Or even just
sort alphabetically - now that I know regexps are supported, it is easy
to get the exact match when I need it.

Just my two cents, maybe others have a diverging opinion.

Thanks for your work anyway,
-- 
Jean Delvare
Suse L3

