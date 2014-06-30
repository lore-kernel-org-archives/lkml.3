Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaF3IwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:52:02 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:46381 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaF3Iv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:51:58 -0400
MIME-Version: 1.0
In-Reply-To: <1404117165.5102.3.camel@smile.fi.intel.com>
References: <1402996306-6811-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1402996306-6811-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<CANeU7QnLad1f4KkLpTGSWB8eD8_La-tACim6rR7DLQ=hggwhOQ@mail.gmail.com>
	<1404117165.5102.3.camel@smile.fi.intel.com>
Date: Mon, 30 Jun 2014 01:51:57 -0700
X-Google-Sender-Auth: bRG36S8oUx6zk7ENKOJSIl0ogZU
Message-ID: <CANeU7Qk6e-CAK_aRTzq=ev_esQ9uGsbc6ihH7m-0=ngoPotVzg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] lib.c: skip --param parameters
From: Christopher Li <sparse@chrisli.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 1:32 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> Hmm... I'd just added test printf to the handle_param() and see if I
> print *next, it is either --param or --param=*. So, using return (next +
> 2) helps, otherwise we end up with the same situation as before patch.

The return value from handle_switch() is a bit tricky. It is actually points to
the current args which about to be expired.

Take a look at this code which invoke the handle_switch().
    for (;;) {
        char *arg = *++args;      <---------------- notice the ++
before the fetch
        if (!arg)
            break;

        if (arg[0] == '-' && arg[1]) {
            args = handle_switch(arg+1, args); <-------- args return here.
            continue;
        }
        add_ptr_list_notag(filelist, arg);
    }

>
> What did I miss?

So the caller loop will perform 1 pointer advance before fetch.
Your code can advance 2 pointer, so that is  total 3 pointer advance.

>
> Which was explicitly mentioned in the commit message.

Sorry about that, I jump to the code first. I later notice that  in
the commit message as well.

Any way, the change I push should fix all that.

Chris
