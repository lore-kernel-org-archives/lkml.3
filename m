Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaI2Ols (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:41:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbaI2Olq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:41:46 -0400
Message-ID: <54296FA3.8080902@suse.cz>
Date: Mon, 29 Sep 2014 16:41:39 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [RFC] kconfig: warn if an unknown symbol is selected
References: <1411769309.15241.37.camel@x220>
In-Reply-To: <1411769309.15241.37.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-27 00:08, Paul Bolle wrote:
> A select of an unknown symbol is basically treated as a nop and is
> silently skipped. This is annoying if the selected symbol contains a
> typo. It can also hide the fact that a treewide symbol cleanup was only
> done partially.
> 
> There are also a few cases were this might have been done on purpose.
> But that anti-pattern should be discouraged. Almost all select
> statements point to a known and reachable symbol. So people will likely
> assume that any selected symbol is actually set. Violating that
> assumption might lead to (subtle) bugs.
> 
> So let's warn when we notice a select of a symbol that is not known in
> the configuration we're creating.
> 
> Rfced-by: Paul Bolle <pebolle@tiscali.nl>

I think this is a good idea, it fits well next to the already present
warning about selecting symbols with unmet dependencies. Feel free to
submit as a regular patch with

Acked-by: Michal Marek <mmarek@suse.cz>

Michal
