Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbaI2QVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:21:46 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:62051 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821AbaI2QVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:21:44 -0400
Message-ID: <1412007702.6334.71.camel@x220>
Subject: Re: [PATCH v7] checkkconfigsymbols.sh: reimplementation in python
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, akpm@linux-foundation.org,
        Stefan Hengelein <stefan.hengelein@fau.de>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Sep 2014 18:21:42 +0200
In-Reply-To: <5429711C.4060008@suse.cz>
References: <1411222524-7850-1-git-send-email-valentinrothberg@gmail.com>
		 <1411919729-5800-1-git-send-email-valentinrothberg@gmail.com>
	 <1411986525.6334.32.camel@x220> <5429711C.4060008@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2014 16:21:42.0868 (UTC) FILETIME=[74BD6140:01CFDC01]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

[This point I already conceded to Valentin, so my remarks are moot for
Valentin's script.]

On Mon, 2014-09-29 at 16:47 +0200, Michal Marek wrote:
> On 2014-09-29 12:28, Paul Bolle wrote:
> >> +STMT = r"^\s*(?:if|select|depends\s+on)\s+" + EXPR
> > 
> > Could please make that "depends on"? Yes, it seems the yacc grammar
> > accepts any amount of whitespace, but that doesn't make it right to use
> > anything other than a single space.
> 
> But then lines that violate coding style would not be checked for real
> errors.

Perhaps my dislike of this element of the grammar won here. There are
probably better ways to enforce proper use of "depends on".

> > (Can the yacc grammar be tweaked to
> > see "depends on" as one, well, token?)
> 
> I don't think this is a good idea. This is a style issue, why make it a
> grammar issue.

Well, a grammar that allows one of its keywords to be written in
different ways makes style and grammar issues overlap. Whatever. I guess
it's just me being annoyed with writing
    git grep -w "depends\s\+on\s\+FOO"

instead of
    git grep -w "depends on FOO"

Ditto for writing a parser for Kconfig files. (Real world examples are
more complicated, but you catch my drift.)


Paul Bolle

