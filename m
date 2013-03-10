Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3CJMV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:21:27 -0400
Received: from pequod.mess.org ([46.65.169.142]:50820 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab3CJMV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:21:26 -0400
Date: Sun, 10 Mar 2013 12:21:23 +0000
From: Sean Young <sean@mess.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 8250.nr_uarts broken in 3.7
Message-ID: <20130310122123.GA25551@pequod.mess.org>
References: <513A6A65.9050706@suse.cz>
 <20130308224950.GM13719@hansolo.jdub.homelinux.org>
 <513A6D1F.5000202@suse.cz>
 <513A6FD4.7000506@suse.cz>
 <513A70CF.9010800@suse.cz>
 <20130308232809.GO13719@hansolo.jdub.homelinux.org>
 <20130308234404.GP13719@hansolo.jdub.homelinux.org>
 <513AFD66.3030404@suse.cz>
 <20130309133014.GQ13719@hansolo.jdub.homelinux.org>
 <513B43BA.3000906@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513B43BA.3000906@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 03:14:18PM +0100, Jiri Slaby wrote:
> This is so disgusting that I will do the following:
> * ack your patch after you change the above (if that works)
> * rename 8250.c to 8250_core.c
> * change 8250_core.ko back to 8250.ko (ie. bring back the old module name)
> * thus switch MODULE_PARAM_PREFIX above to "8250_core."
> * deprecate all the newly added 8250_core.* params somehow and schedule
> for removal. IMO this warrants a kernel config option like
> CONFIG_8250_DEPRECATED_MODULE_PARAMS.
> 
> We have a lesson learned.

Indeed. In the patch that broke things, I renamed the module rather than 
the 8250.c source file in order to keep the patch small, but obviously 
did not consider the consequences well enough. I'm sorry about the mess 
I created.


Sean
