Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbaGVX7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:59:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55853 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112AbaGVX7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:59:06 -0400
X-Sasl-enc: S3dwzTN5Jdy0Y2P2X9MF2D6yHO+z7CWGwrhYXkC+0/qk 1406073544
Date: Tue, 22 Jul 2014 16:59:03 -0700
From: Greg KH <greg@kroah.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kamal Mostafa <kamal@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel-team@lists.ubuntu.com,
        Roland McGrath <roland@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 3.8 106/116] x86_32, entry: Do syscall exit work on
 badsys (CVE-2014-4508)
Message-ID: <20140722235903.GA12525@kroah.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
 <1406067727-19683-107-git-send-email-kamal@canonical.com>
 <CALCETrWTS=z7ZD78JppwbXJKo7HA3xTJYQS=DXLbw5bNyUA_3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWTS=z7ZD78JppwbXJKo7HA3xTJYQS=DXLbw5bNyUA_3g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:27:59PM -0700, Andy Lutomirski wrote:
> On Tue, Jul 22, 2014 at 3:21 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> > 3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Andy Lutomirski <luto@amacapital.net>
> >
> > commit 554086d85e71f30abe46fc014fea31929a7c6a8a upstream.
> >
> > The bad syscall nr paths are their own incomprehensible route
> > through the entry control flow.  Rearrange them to work just like
> > syscalls that return -ENOSYS.
> >
> > This fixes an OOPS in the audit code when fast-path auditing is
> > enabled and sysenter gets a bad syscall nr (CVE-2014-4508).
> >
> > This has probably been broken since Linux 2.6.27:
> > af0575bba0 i386 syscall audit fast-path
> 
> Don't apply this without:
> 
> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=8142b215501f8b291a108a202b3a053a265b03dd
> 
> Sorry!

As that isn't in Linus's tree yet, don't apply that one either...

thanks,

greg k-h
