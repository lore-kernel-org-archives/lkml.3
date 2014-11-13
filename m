Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795AbaKMXeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:34:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934235AbaKMXeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:34:17 -0500
Date: Thu, 13 Nov 2014 15:34:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: josh@joshtriplett.org
Cc: Pieter Smith <pieter@boesman.nl>, Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 51/56] drivers/char/mem: support compiling out splice
Message-ID: <20141113233416.GC7678@kroah.com>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
 <1415913813-362-52-git-send-email-pieter@boesman.nl>
 <20141113220911.GA546@kroah.com>
 <CAPho-_JJGy0cwBVfWKL1Gt9ZQZM+Odo7W05bKQ2JLO+TM-ABJA@mail.gmail.com>
 <20141113223150.GB30412@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113223150.GB30412@cloud>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 02:31:50PM -0800, josh@joshtriplett.org wrote:
> [Please don't top-post.]
> 
> On Thu, Nov 13, 2014 at 11:23:46PM +0100, Pieter Smith wrote:
> > Okay with moving the relevant functions to a new translation unit and
> > squashing it out in the Makefile
> 
> No, you don't need to do that either.  Mark pipe_to_null and
> splice_write_null as __maybe_unused, then wrap the initialization of
> .splice_write = splice_write_null to make it .splice_write =
> splice_p(splice_write_null).  That will avoid adding a single ifdef.

Again, ick, no.  You aren't saving anything "real" at all, just take out
the splice core code, leave the file pointer alone, and never do that
horrid "splice_p" stuff, ick ick ick.

greg k-h
