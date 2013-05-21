Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3EUOmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:42:33 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38565 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab3EUOmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:42:31 -0400
Date: Tue, 21 May 2013 22:42:15 +0800
From: Wang YanQing <udknight@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: gregkh@linuxfoundation.org, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY:vt: convert remain take_over_console's users to
 do_take_over_console
Message-ID: <20130521144215.GA5302@udknight.homenetwork>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Peter Hurley <peter@hurleysoftware.com>, gregkh@linuxfoundation.org,
	sfr@canb.auug.org.au, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20130521051511.GA11435@udknight>
 <519B7249.2070207@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519B7249.2070207@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 09:10:33AM -0400, Peter Hurley wrote:
> I would rather revert dc9641895abb which purported to delete
> _unneeded_ functions than have this. Obviously the functions
> were needed.
> 

Hi Peter, this series patches' goal is to reduce codes'
redundance and function duplication. But if we keep take_over_console, 
then we have to rewrite it as a trivial wrapper over do_take_over_console,
or we have to keep bind_con_driver and register_con_driver, and this
will bring use codes' redundance.

And if we rewrite take_over_console as a wrapper over
do_take_over_console, it is so trivial, delete it and let kernel
use the unified version of APIs will simplify the APIs.

Thanks.
