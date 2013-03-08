Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231Ab3CHGEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:04:06 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:60566 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3CHGEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:04:04 -0500
Date: Fri, 8 Mar 2013 11:33:41 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: oskar.andero@sonymobile.com, linux-kernel@vger.kernel.org,
        davem@davemloft.net, anil.s.keshavamurthy@intel.com,
        radovan.lekanovic@sonymobile.com,
        =?utf-8?B?77+9IDxiam9ybi5kYXZpZHNzb25Ac29ueW1vYmlsZS5jb20+?=@thinktux.in.ibm.com
Subject: Re: [PATCH] Kprobes blacklist: Conditionally add x86-specific
	symbols
Message-ID: <20130308060341.GB4029@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1362653070-24035-1-git-send-email-oskar.andero@sonymobile.com> <513967BD.9010602@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513967BD.9010602@hitachi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030806-3620-0000-0000-0000018A04A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 01:23:25PM +0900, Masami Hiramatsu wrote:
> (2013/03/07 19:44), oskar.andero@sonymobile.com wrote:
> > From: Bjorn Davidsson <bjorn.davidsson@sonymobile.com>
> > 
> > The kprobes blacklist contains x86-specific symbols.
> > Looking for these in kallsyms takes unnecessary time
> > during startup on non-X86 platform.
> > Added #ifdef CONFIG_X86 around them.
> 
> Right. however, it might be better break that into
> common and arch-specific lists, because there may be
> other arch-specific non-probe-able functions on each
> architecture...

Agreed. CONFIG_<arch> in kernel/* is not the right thing to do IMO.

You are moving the blacklist initialization to later in the next patch,
so how much overhead will it then be?

Ananth

