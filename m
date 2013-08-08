Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966221Ab3HHTQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:16:59 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47457 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966174Ab3HHTQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:16:56 -0400
Date: Thu, 8 Aug 2013 21:16:50 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>,
        Kevin Hilman <khilman@linaro.org>, sedat.dilek@gmail.com,
        "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-ID: <20130808191650.GB3282@free.fr>
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
 <CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com>
 <20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au>
 <87zjsted0c.fsf@linaro.org>
 <20130808102228.d2034d3a4c986d2970926ab9@canb.auug.org.au>
 <20130808103614.a039da2f236154b52329b28b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130808103614.a039da2f236154b52329b28b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen, All,

On 2013-08-08 10:36 +1000, Stephen Rothwell spake thusly:
> On Thu, 8 Aug 2013 10:22:28 +1000 Stephen Rothwell <sfr@canb.auug.org.au>
> wrote:
> >
> > More quick testing with an empty file: v3.9 is OK, v3.10 gives
> > CONFIG_MODULES unset.

Sorry, I don't understand the above. Can you elaborate on what you did,
what you got, what expected, so I can try to reproduce and fix this,
please?

> Bisecting gives:
> 
> cfa98f2e0ae956feca935573e977d7661a9561b9 is the first bad commit
> commit cfa98f2e0ae956feca935573e977d7661a9561b9
> Author: Yann E. MORIN <yann.morin.1998@free.fr>
> Date:   Wed Apr 24 22:00:04 2013 +0200
> 
>     kconfig: do not override symbols already set
>     
>     For randconfig, if a list of required symbols is specified with
>     KCONFIG_ALLCONFIG, such symbols do not "have a value" as per
>     sym_has_value(), but have the "valid" flag set.
>     
>     Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> And reverting that commit in v3.10 gives me CONFIG_MODULES=y.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
