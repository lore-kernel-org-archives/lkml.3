Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaKFPLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:11:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaKFPLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:11:39 -0500
Date: Thu, 6 Nov 2014 16:11:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
In-Reply-To: <1415284748-14648-3-git-send-email-sjenning@redhat.com>
Message-ID: <alpine.LNX.2.00.1411061607250.29198@pobox.suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com> <1415284748-14648-3-git-send-email-sjenning@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014, Seth Jennings wrote:

> This commit introduces code for the live patching core.  It implements
> an ftrace-based mechanism and kernel interface for doing live patching
> of kernel and kernel module functions.
> 
> It represents the greatest common functionality set between kpatch and
> kgraft and can accept patches built using either method.
> 
> This first version does not implement any consistency mechanism that
> ensures that old and new code do not run together.  In practice, ~90% of
> CVEs are safe to apply in this way, since they simply add a conditional
> check.  However, any function change that can not execute safely with
> the old version of the function can _not_ be safely applied in this
> version.

Thanks a lot for having started the work on this!

We will be reviewing it carefully in the coming days and will getting back 
to you (I was surprised to see that that diffstat indicates that it's 
actually more code than our whole kgraft implementation including the 
consistency model :) ).

I have one questions right away though.

> +/****************************************
> + * dynamic relocations (load-time linker)
> + ****************************************/
> +
> +/*
> + * external symbols are located outside the parent object (where the parent
> + * object is either vmlinux or the kmod being patched).
> + */

I have no ideas what dynrela is, and quickly reading the source doesn't 
really help too much.

Could you please provide some explanation / pointer to some documentation, 
explaining what exactly it is, and why should it be part of the common 
infrastructure?

Thanks,

-- 
Jiri Kosina
SUSE Labs
