Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab3JOMEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:04:13 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:64846 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143Ab3JOMEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 08:04:10 -0400
Date: Tue, 15 Oct 2013 14:04:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Joe Perches <joe@perches.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131015120404.GA2402@gmail.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <20131012172124.GA18241@gmail.com>
 <20131014202854.GH26880@hmsreliant.think-freely.org>
 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
 <1381790278.16896.2.camel@joe-AO722>
 <1381790686.2045.24.camel@edumazet-glaptop.roam.corp.google.com>
 <1381790982.16896.7.camel@joe-AO722>
 <20131015074123.GB25493@gmail.com>
 <20131015105159.GA8682@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015105159.GA8682@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Tue, Oct 15, 2013 at 09:41:23AM +0200, Ingo Molnar wrote:
> > Most processors have hundreds of cachelines even in their L1 cache.
> > Thousands in the L2 cache, up to hundreds of thousands.
> 
> Also, I have this hazy memory of prefetch hints being harmful in some
> situations: https://lwn.net/Articles/444344/

Yes, for things like random list walks they tend to be harmful - the 
hardware is smarter.

For something like a controlled packet stream they might be helpful.

Thanks,

	Ingo
