Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3EIP1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:27:46 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:51388 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3EIP1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:27:44 -0400
Date: Thu, 9 May 2013 23:27:31 +0800
From: Wang YanQing <udknight@gmail.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Michal Marek <mmarek@suse.cz>,
        Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH v3] kconfig: sort found symbols by relevance
Message-ID: <20130509152731.GA3355@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jean Delvare <jdelvare@suse.de>, Michal Marek <mmarek@suse.cz>,
	Roland Eggner <edvx1@systemanalysen.net>
References: <1367826629.4494.30.camel@chaos.site>
 <1367874931-6251-1-git-send-email-yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367874931-6251-1-git-send-email-yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 11:15:31PM +0200, Yann E. MORIN wrote:
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> When searching for symbols, return the symbols sorted by relevance.
> 
> Sorting is done as thus:
>   - first, symbols with a prompt,   [1]
>   - then, smallest offset,          [2]
>   - then, shortest match,           [3]
>   - then, highest relative match,   [4]
>   - finally, alphabetical sort      [5]
> 
> So, searching (eg.) for 'P.*CI' :
> 
> [1] Symbols of interest are probably those with a prompt, as they can be
>     changed, while symbols with no prompt are only for info. Thus:
>         PCIEASPM comes before PCI_ATS

Search the value of symbols with no prompt are useful too

> [2] Symbols that match earlier in the name are to be preferred over
>     symbols which match later. Thus:
>         PCI_MSI comes before WDTPCI

We can achieve this with ^PCI regular search

> [3] The shortest match is (IMHO) more interesting than a longer one.
>     Thus:
>         PCI comes before PCMCIA

We can achieve this with ^PCI regular search plus your previous heuristic

> [4] The relative match is the ratio of the length of the match against
>     the length of the symbol. The more of a symbol name we match, the
>     more instersting that symbol is. Thus:
>         PCIEAER comes before PCIEASPM

This is what your first heuristic

> [5] As fallback, sort symbols alphabetically
This is in your first heuristic too.

> This heuristic tries hard to get interesting symbols first in the list.
I don't mean your this heuristic is bad, but
maybe provide mechanism to user will make guesser life easier.

Thanks.
