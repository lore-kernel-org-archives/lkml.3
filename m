Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaEIMW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:22:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408AbaEIMWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:22:54 -0400
Date: Fri, 9 May 2014 14:22:52 +0200 (CEST)
From: Michael Matz <matz@suse.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Udo Seidel <udoseidel@gmx.de>
Subject: Re: kgr: dealing with optimalizations? (was Re: [RFC 06/16] kgr:
 add Documentat)ion
In-Reply-To: <20140509093154.GA4877@xo-6d-61-c0.localdomain>
Message-ID: <alpine.LNX.2.00.1405091419430.23942@wotan.suse.de>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz> <1398868249-26169-7-git-send-email-jslaby@suse.cz> <20140506110312.GA15033@xo-6d-61-c0.localdomain> <20140509093154.GA4877@xo-6d-61-c0.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 9 May 2014, Pavel Machek wrote:

> Ok, one big question: you are replacing single functions, and assume 
> that's ok, right?
> 
> But ... is it ok? gcc is allowed to do optimalization on whole source 
> file (and whole source tree with LTO).  How do you prevent situation 
> where changing function foo() breaks optimalization in function bar()?

If such situation (behaviour changes with optimization) happens it's 
either compiler or a source bug, so is of no direct concern to kgraft.  
If you want to exchange an inlined function foo you of course have to take 
care of actually exchanging all functions into which foo was inlined.  
For that you need the inline tree for all kernels for which you want to 
support kgrafting.

> Is turning off inter-procedural and inter-module optimalizations needed 
> for kgraft to work?

No.


Ciao,
Michael.
