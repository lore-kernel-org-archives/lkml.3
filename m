Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbaFQNpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:45:11 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39885 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbaFQNpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:45:09 -0400
Date: Tue, 17 Jun 2014 21:45:01 +0800
From: Real Name <enjoymindful@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jdike@addtoit.com
Subject: Re: [PATCH] remove csum_partial_copy_generic_i386 to clean up
 exception table
Message-ID: <20140617134501.GA3604@name>
References: <538F275B.7000508@nod.at>
 <1401941724-6703-1-git-send-email-enjoymindful@gmail.com>
 <1401941724-6703-2-git-send-email-enjoymindful@gmail.com>
 <5390E5FD.5030400@nod.at>
 <20140609054556.GA2465@name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609054556.GA2465@name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 01:45:56PM +0800, Real Name wrote:
> On Thu, Jun 05, 2014 at 11:49:49PM +0200, Richard Weinberger wrote:
> > Am 05.06.2014 06:15, schrieb Honggang Li:
> > > arch/x86/um/checksum_32.S had been copy & paste from x86. When build
> > > x86 uml, csum_partial_copy_generic_i386 mess up the exception table.
> > > In fact, exception table dose not work in uml kernel.
> > 
> > Are you sure that exception tables do not work on UML?
> > I said, I'm not sure. Can you please find out?
> 
> I think we can't test the exception table with linux-next uml kernel, because
> the exception table is broken.
>

This patch is the root source of the broken exception table of UML
kernel. 

linux]# git bisect visualize 
commit 706276543b699d80f546e45f8b12574e7b18d952
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Fri Apr 20 17:12:48 2012 -0700

    x86, extable: Switch to relative exception table entries
