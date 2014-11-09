Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaKIUSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 15:18:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaKIUSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 15:18:13 -0500
Date: Sun, 9 Nov 2014 12:16:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141109201641.GA21349@kroah.com>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 08:39:06AM -0600, Seth Jennings wrote:
> This patchset implements an ftrace-based mechanism and kernel interface for
> doing live patching of kernel and kernel module functions.  It represents the
> greatest common functionality set between kpatch [1] and kGraft [2] and can
> accept patches built using either method.  This solution was discussed in the
> Live Patching Mini-conference at LPC 2014 [3].
> 
> The model consists of a live patching "core" that provides an interface for
> other "patch" kernel modules to register patches with the core.
> 
> Patch modules contain the new function code and create an lp_patch
> structure containing the required data about what functions to patch, where the
> new code for each patched function resides, and in which kernel object (vmlinux
> or module) the function to be patch resides.  The patch module then invokes the
> lp_register_patch() function to register with the core module, then
> lp_enable_patch() to have to core module redirect the execution paths using
> ftrace.
> 
> An example patch module can be found here:
> https://github.com/spartacus06/livepatch/blob/master/patch/patch.c
> 
> The live patching core creates a sysfs hierarchy for user-level access to live
> patching information.  The hierarchy is structured like this:
> 
> /sys/kernel/livepatch
> /sys/kernel/livepatch/<patch>
> /sys/kernel/livepatch/<patch>/enabled
> /sys/kernel/livepatch/<patch>/<object>
> /sys/kernel/livepatch/<patch>/<object>/<func>
> /sys/kernel/livepatch/<patch>/<object>/<func>/new_addr
> /sys/kernel/livepatch/<patch>/<object>/<func>/old_addr

You are creating sysfs attributes with no Documentation/ABI/ entries,
please fix that in future patches.

thanks,

greg k-h
