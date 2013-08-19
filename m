Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab3HSLJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:09:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab3HSLJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:09:38 -0400
Date: Mon, 19 Aug 2013 12:09:17 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [uml-devel] [PATCH] um: ubd: Add REQ_FLUSH suppport
Message-ID: <20130819110917.GD5918@redhat.com>
References: <1376777374-17521-1-git-send-email-richard@nod.at>
 <20130819091839.GX5918@redhat.com>
 <CAMuHMdXgGPFx6OwHdc73bY6Cb1jYHbjpEqq6e+YC9RuvJYRxDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXgGPFx6OwHdc73bY6Cb1jYHbjpEqq6e+YC9RuvJYRxDw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 12:13:14PM +0200, Geert Uytterhoeven wrote:
> Hi Richard,
> 
> On Mon, Aug 19, 2013 at 11:18 AM, Richard W.M. Jones <rjones@redhat.com> wrote:
> > On Sun, Aug 18, 2013 at 12:09:34AM +0200, Richard Weinberger wrote:
> >> UML's block device driver does not support write barriers,
> >> to support this this patch adds REQ_FLUSH suppport.
> >> Every time the block layer sends a REQ_FLUSH we fsync() now
> >> our backing file to guarantee data consistency.
> >
> > This fixes the sync problem I saw before.  So:
> 
> What's the impact on your performance figures?

It just moves the sync into the main process, thus making the
"write-no-upload" test time *increase* to what we expected (the same
as KVM).

This doesn't address the main performance issue, which appears to lie
in the serial port emulation.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/
