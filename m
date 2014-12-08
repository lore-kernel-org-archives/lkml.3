Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaLHHLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:11:36 -0500
Received: from 1wt.eu ([62.212.114.60]:48992 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbaLHHLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:11:35 -0500
Date: Mon, 8 Dec 2014 08:11:25 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 10/25] x86, espfix: Make it possible to disable 16-bit support
Message-ID: <20141208071125.GA27435@1wt.eu>
References: <20141206174148.851443989@1wt.eu> <1418007534.11886.58.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418007534.11886.58.camel@decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 02:58:54AM +0000, Ben Hutchings wrote:
> On Sat, 2014-12-06 at 18:41 +0100, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: "H. Peter Anvin" <hpa@zytor.com>
> > 
> > commit 34273f41d57ee8d854dcd2a1d754cbb546cb548f upstream.
> > 
> > Embedded systems, which may be very memory-size-sensitive, are
> > extremely unlikely to ever encounter any 16-bit software, so make it
> > a CONFIG_EXPERT option to turn off support for any 16-bit software
> > whatsoever.
> > 
> > Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > Link: http://lkml.kernel.org/r/1398816946-3351-1-git-send-email-hpa@linux.intel.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > (cherry picked from 3.2 commit 70d87cbbd92a3611655b39003176ee1033796bf7)
> > [wt: backport notes for 2.6.32 :
> >   - Fixed arch/x86/kernel/ldt.c (no IS_ENABLED on 2.6.32).
> >   - No CONFIG_EXPERT condition in 2.6.32.
> > /wt]
> [...]
> 
> It used to be called CONFIG_EMBEDDED, so you could s/EXPERT/EMBEDDED/,
> but it doesn't matter much.

I hesitated on this one and thought that EMBEDDED was currently not selected
by most server configs and users would not necessarily think about enabling
it to discover the new option, since it was made for a different purpose. In
the end, presenting the new option to users is not a bad thing considering
that the purpose is to help them improve their security.

Regards,
Willy

