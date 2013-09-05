Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab3IETVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:21:13 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:34252 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab3IETVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:21:11 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CDCC23@ORSMSX106.amr.corp.intel.com>
References: <20130905131814.GA24274@osiris>
	<CA+55aFyZ8xLWiPcP3jcnVApQOqAvpo_fshSvGpdpW42iRutPcQ@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDC7F7@ORSMSX106.amr.corp.intel.com>
	<CA+55aFyevZQG5pEz-iJF6MFEMpwJD=biB-x852ki0spOM293Sg@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDCC23@ORSMSX106.amr.corp.intel.com>
Date: Thu, 5 Sep 2013 12:21:10 -0700
X-Google-Sender-Auth: b58S_6TXmTzRAVxq1Pg-pSFPtvA
Message-ID: <CA+55aFw_Rovv7YTb62q5NQvucM5ks8+HXcsTOJ-oJ+kqmHop4A@mail.gmail.com>
Subject: Re: [PATCH] lockref: remove cpu_relax() again
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 11:57 AM, Luck, Tony <tony.luck@intel.com> wrote:
>
> Not "tons", just two.  You can ask for "acquire" or "release" semantics,
> there is no relaxed option.

Seriously? You can't just do a cache-coherent cmpxchg without extra
serialization? Oh well.

> Worse still - early processor implementations actually just ignored
> the acquire/release and did a full fence all the time.  Unfortunately
> this meant a lot of badly written code that used .acq when they really
> wanted .rel became legacy out in the wild - so when we made a cpu
> that strictly did the .acq or .rel ... all that code started breaking - so
> we had to back-pedal and keep the "legacy" behavior of a full fence :-(

Ugh. Can you try what happens with the weaker release-semantics
performance-wise for that code? Do it *just* for the lockref code..

         Linus
