Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab3AYS3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:29:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39039 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279Ab3AYS3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:29:25 -0500
Date: Fri, 25 Jan 2013 19:32:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>, Dmitry Torokhov <dtor@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH -v2 2/2] x86: Make Linux guest support optional
Message-ID: <20130125183213.GB1380@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	X86 ML <x86@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
	olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
	Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
	Borislav Petkov <bp@suse.de>, Dmitry Torokhov <dtor@vmware.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>
References: <20130125100655.GC23404@pd.tnic>
 <1359136777-4512-2-git-send-email-bp@alien8.de>
 <20130125181251.GA5563@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130125181251.GA5563@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:12:51AM -0800, Dmitry Torokhov wrote:
> Hi Borislav,
> 
> On Fri, Jan 25, 2013 at 06:59:37PM +0100, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > Put all config options needed to run Linux as a guest behind a
> > CONFIG_HYPERVISOR_GUEST menu so that they don't get built-in by
> > default but selected by the user. Also, move x86_hyper into an
> > unconditionally-built compilation unit because it is exported with the
> > non-GPL flavour and we can't know whatever uses it on the outside.
> 
> I am confused by this statement... How can EXPORT_SYMBOL() vs
> EXPORT_SYMBOL_GPL() help you determining if it is used out of tree or
> not?

Maybe this wasn't formulated clear enough - I wanted to say that with
the !GPL flavor, any code (proprietary included) can link to those
symbols and we cannot know who uses it and if we hide that symbol,
someone would probably come crying.

Because if we could, I would've done trivial accessor functions which
would return NULL when CONFIG_HYPERVISOR_GUEST is not set so that those
cases build and boot fine, and we wouldn't have the need to have this
symbol always present (like is the case now and I had to move it to
setup.c).

If it were _GPL, we would've fixed all its users to switch to the
accessors.

Makes more sense?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
