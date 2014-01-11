Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaAKUd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:33:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaAKUdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:33:54 -0500
Date: Sat, 11 Jan 2014 12:33:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, peter.p.waskiewicz.jr@intel.com,
        linux-kernel@vger.kernel.org,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: [PATCH v3 1/2] Staging: lustre: Refactor the function
 interval_erase_color() in /lustre/ldlm/interval_tree.c
Message-ID: <20140111203358.GA6501@kroah.com>
References: <52c9bc8b.ca41420a.775b.ffff98ce@mx.google.com>
 <1389438033-5928-1-git-send-email-monamagarwal123@gmail.com>
 <20140111111931.GV30234@mwanda>
 <CAFB2WuU=aGwVM7n1Zy7OSnEaR00ZWyPNXGw9A5MBk1p0+LSKZg@mail.gmail.com>
 <20140111113959.GW30234@mwanda>
 <CAFB2WuUaf9x42U0xTyczpw1=9kLaLLPC9v0f5JxpS7j+umt9kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFB2WuUaf9x42U0xTyczpw1=9kLaLLPC9v0f5JxpS7j+umt9kw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 05:14:35PM +0530, Monam Agarwal wrote:
> On Sat, Jan 11, 2014 at 5:09 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Sat, Jan 11, 2014 at 04:56:44PM +0530, Monam Agarwal wrote:
> >> I took n as a flag to decide whether parent->in_left == node is true
> >> or not in the called function.
> >
> > So "n" stands for "node"?
> >
> >> Should I use some other name for the flag.
> >
> >
> > Yes.
> >
> 
> Will "flag" be a suitable name?

Ick, no.  You don't want a "flag" to have to determine what the logic is
for a given function.  That just causes confusion and makes things
really hard to read and understand over time.

This whole function looks like a red/black tree, or something like that.
Shouldn't we just be using the in-kernel implementation of this?  And if
not, then you really need to get the feedback of the code's original
authors as you might be changing the algorithm in ways that could cause
big problems.

thanks,

greg k-h
