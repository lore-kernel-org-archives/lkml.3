Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111Ab3CHNRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:17:40 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3151 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932987Ab3CHNRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:17:38 -0500
From: <oskar.andero@sonymobile.com>
Date: Fri, 8 Mar 2013 14:17:35 +0100
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>,
        "??? <bjorn.davidsson@sonymobile.com>@thinktux.in.ibm.com" 
	<=?utf-8?B?77+9IDxiam9ybi5kYXZpZHNzb25Ac29ueW1vYmlsZS5jb20+?=@thinktux.in.ibm.com>
Subject: Re: [PATCH] Kprobes blacklist: Conditionally add x86-specific symbols
Message-ID: <20130308131735.GJ26148@caracas.corpusers.net>
References: <1362653070-24035-1-git-send-email-oskar.andero@sonymobile.com>
 <513967BD.9010602@hitachi.com>
 <20130308060341.GB4029@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130308060341.GB4029@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07:03 Fri 08 Mar     , Ananth N Mavinakayanahalli wrote:
> On Fri, Mar 08, 2013 at 01:23:25PM +0900, Masami Hiramatsu wrote:
> > (2013/03/07 19:44), oskar.andero@sonymobile.com wrote:
> > > From: Bjorn Davidsson <bjorn.davidsson@sonymobile.com>
> > > 
> > > The kprobes blacklist contains x86-specific symbols.
> > > Looking for these in kallsyms takes unnecessary time
> > > during startup on non-X86 platform.
> > > Added #ifdef CONFIG_X86 around them.
> > 
> > Right. however, it might be better break that into
> > common and arch-specific lists, because there may be
> > other arch-specific non-probe-able functions on each
> > architecture...
> 
> Agreed. CONFIG_<arch> in kernel/* is not the right thing to do IMO.
> 
> You are moving the blacklist initialization to later in the next patch,
> so how much overhead will it then be?

Well, it's not crucial for the boot time, but it is still a small
optimization.

-Oskar
