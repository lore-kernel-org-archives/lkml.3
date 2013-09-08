Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab3IHRXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 13:23:00 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58642 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758529Ab3IHRW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 13:22:57 -0400
Message-ID: <1378660975.2429.14.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Date: Sun, 08 Sep 2013 10:22:55 -0700
In-Reply-To: <1378660541.2300.19.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
	 <1378660284.2429.11.camel@dabdike.int.hansenpartnership.com>
	 <1378660541.2300.19.camel@x230>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-08 at 17:15 +0000, Matthew Garrett wrote:
> On Sun, 2013-09-08 at 10:11 -0700, James Bottomley wrote:
> 
> > That's not true if you look at the use cases.  Distros use signed
> > modules to taint the kernel:  insert an unsigned one and the kernel
> > taints; insert a properly signed one and it doesn't.  They use it for
> > support to tell if you've been adhering to your contract.  That use case
> > has nothing to do with security.
> 
> That use case has nothing to do with this patch, either. It's completely
> unaffected. This only triggers if the kernel is configured to refuse the
> loading of unsigned modules.
> 
> > The analogy is rubbish.  I can give away CAP_SYS_MODULE and enforce what
> > modules those I've given the permission to can insert by signing them.
> > I keep CAP_SYS_BOOT, so they can't use kexec to subvert this.
> 
> Yeah, that's a good argument for why capabilities are mostly pointless.
> If I have CAP_SYS_BOOT I can give myself any other capabilities. Why
> bother?

It's an argument that CAP_SYS_BOOT is too powerful yes, but if you
recall, I said I keep that one.  In the rather lame analogy, what I do
by giving away CAP_SYS_MODULE and enforcing module signing while keeping
CAP_SYS_BOOT is allow people into my conservatory to play with the
plants but not into my house to steal the silver ... saying CAP_SYS_BOOT
is too powerful doesn't affect that use case because I haven't given
away CAP_SYS_BOOT.

James

