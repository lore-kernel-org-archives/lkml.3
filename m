Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3DNPRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 11:17:41 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44887 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab3DNPRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 11:17:40 -0400
Date: Sun, 14 Apr 2013 10:24:58 -0400
From: Anton Vorontsov <anton@enomsg.org>
To: Bryan Freed <bfreed@chromium.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v6] pstore/ram: Add ramoops support for the Flattened
 Device Tree.
Message-ID: <20130414142441.GA3619@teo>
References: <1347042576-17675-1-git-send-email-bfreed@chromium.org>
 <20120908052907.GA4724@lizard>
 <20120917062302.GA768@lizard>
 <CAL_JsqK_L9nN6+oxUQzNwFjbFf3+3NroeEwzbMdPS4T6=Mnemg@mail.gmail.com>
 <20130407174313.GA7168@lizard>
 <CAEYUcX0rQKDGD3_pbc7JnDO6WJ_QMd8AWW+X1giNVL313wODyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEYUcX0rQKDGD3_pbc7JnDO6WJ_QMd8AWW+X1giNVL313wODyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 12:54:01PM -0700, Bryan Freed wrote:
[...]
> And as a more general question, why should we try not to put
> configuration in the device tree?  It seems like a great (and
> portable) place to put this stuff.
> It certainly seems better to have it there than hardwired in the
> kernel or tacked onto the kernel command line.

But then we have two in-kernel APIs to pass kernel parameters? So we'll
have to maintain two ways of passing the options for each driver. That is
hardly a good solution.

If you would like to see a convenient way to pass kernel/module options
via the device tree, I would suggest implementing something like this:

chosen {
	kernel-options {
		linux,pstore.record-size = 123;
		linux,foo = "bar";
	};
};

And then let the kernel translate all these to module_param_*().

I am still not sure about placing the options along with devices layout,
but if we go this route, then that is also viable:

pstore-node {
	linux,pstore.record-size = 123;
};

And translate "linux,*" this to module_param_*().

How does that sound?

Thanks,
Anton
