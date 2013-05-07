Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab3EGBf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:35:29 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:49096 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab3EGBf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:35:27 -0400
Date: Tue, 7 May 2013 09:35:11 +0800
From: Wang YanQing <udknight@gmail.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH] kconfig: sort found symbols by relevance
Message-ID: <20130507013511.GA4769@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Jean Delvare <jdelvare@suse.de>,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michal Marek <mmarek@suse.cz>,
	Roland Eggner <edvx1@systemanalysen.net>
References: <1367826629.4494.30.camel@chaos.site>
 <1367845365-13316-1-git-send-email-yann.morin.1998@free.fr>
 <1367854112.4569.137.camel@chaos.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367854112.4569.137.camel@chaos.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 05:28:32PM +0200, Jean Delvare wrote:
> Le Monday 06 May 2013 à 15:02 +0200, Yann E. MORIN a écrit :
> > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > 
> > When searching for symbols, return the symbols sorted by relevance.
> > 
> > Relevance is the ratio of the length of the matched string and the
> > length of the symbol name. Symbols of equal relevance are sorted
> > alphabetically.
> I did not look at the code, only tested it, and it does what I asked for
> originally: exact match is listed first. So thank you :)
> 
> However I am not sure if your implementation is what we want. Your
> definition of "relevance" is somewhat arbitrary and may not be
> immediately to others. For example, my own definition of "relevance" was
> that symbols which start with the subject string are more relevant than
> the symbols which have the string in the middle. Others would possibly
> have other definitions.

But no matter what the definition of relevance in text search, 
in the middle or start or end, the searcher always want the "results" 
look like what they input literal.

I think Yann's definition make sense. It is just a pattern matching ratio question.

If you want in start, just use ^PCI(reguar search), then with the help of 
this patch, will make people life easier.

This patch is not to replace the regular search, you can just use them together.

BTW, I haven't read the code right now, maybe I will read it tonight.
I test it, it works well, and I find it is useful to use it with regular search.

Thanks.
