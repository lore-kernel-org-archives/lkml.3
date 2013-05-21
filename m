Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab3EUQaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:30:13 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40406 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3EUQaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:30:11 -0400
Date: Wed, 22 May 2013 00:29:58 +0800
From: Wang YanQing <udknight@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>, gregkh@linuxfoundation.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY:vt: convert remain take_over_console's users to
 do_take_over_console
Message-ID: <20130521162958.GA1927@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Peter Hurley <peter@hurleysoftware.com>, gregkh@linuxfoundation.org,
	sfr@canb.auug.org.au, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20130521051511.GA11435@udknight>
 <519B7249.2070207@hurleysoftware.com>
 <20130521144215.GA5302@udknight.homenetwork>
 <519B976A.3050708@hurleysoftware.com>
 <20130521161849.GA11322@udknight.homenetwork>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521161849.GA11322@udknight.homenetwork>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 12:18:49AM +0800, Wang YanQing wrote:
> > Except now you're spreading the brokenness that is console_lock()
> > over many more source files than the single-use case of
> > do_take_over_console().
> 
> > The actual interface is take_over_console(); the _workaround_ is
> > exposing do_take_over_console() for fbcon to wrap.
> 
> This _workaround_ willn't work, take_over_console will hold console_lock internal,
> but do_take_over_console need caller hold console_lock, then we can't rewrite 
> do_take_over_console as a wrap base on take_over_console. 
> 
> But the reverse is ok. So if we have to do it, then the actual interface 
> is do_take_over_console, and the "_workaround_" is exposing take_over_console 
> as a wrap base on do_take_over_console.

But if we do this, then we have two version functions do the same thing except
caller/callee hold lock, I can't see much sense to have them at the same time.

Thanks.
