Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3ASDeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 22:34:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47139 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3ASDeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 22:34:09 -0500
Date: Sat, 19 Jan 2013 03:34:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2 19/76] ARC: Signal handling
Message-ID: <20130119033407.GK4939@ZenIV.linux.org.uk>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
 <1358511930-7424-20-git-send-email-vgupta@synopsys.com>
 <20130119032357.GB23552@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130119032357.GB23552@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 03:23:57AM +0000, Al Viro wrote:
> ITYM current_pt_regs()...
> 
> > +	if (unlikely(is_do_ss_needed(magic)))
> > +		if (do_sigaltstack(&sf->uc.uc_stack, NULL, regs->sp) == -EFAULT)
> 	if (!restore_altstack(&sf->uc.uc_stack))
> please...

... only without the braino - if (restore_altstack(...))
