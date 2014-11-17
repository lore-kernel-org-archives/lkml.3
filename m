Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaKQLiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:38:08 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:34068 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaKQLiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:38:06 -0500
Date: Mon, 17 Nov 2014 11:37:34 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use
 setgroups to drop groups
Message-ID: <20141117113734.396798e6@lxorguk.ukuu.org.uk>
In-Reply-To: <20141116045232.GB18880@thin>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
	<0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
	<87d28osceg.fsf@x220.int.ebiederm.org>
	<20141115192924.GB19060@thin>
	<CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
	<20141115202042.GA20900@thin>
	<20141116020511.GB5507@thunk.org>
	<6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org>
	<20141116034005.GC5507@thunk.org>
	<20141116045232.GB18880@thin>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> optional), I can do that too.  The security model of "having a group
> gives you less privilege than not having it" seems crazy, but
> nonetheless I can see a couple of easy ways that we can avoid breaking

It's an old pattern of use that makes complete sense in a traditional
Unix permission world because it's the only way to do "exclude {list}"
nicely. Our default IMHO shouldn't break this.

> that pattern, no_new_privs being one of them.  I'd like to make sure
> that nobody sees any other real-world corner case that unprivileged
> setgroups would break.

Barring the usual risk of people doing improper error checking I don't
see one immediately.

For containers I think it actually makes sense that the sysctl can be
applied per container anyway.

Alan
