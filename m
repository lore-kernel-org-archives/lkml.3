Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaH2OoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:44:11 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:40183 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaH2OoJ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Fri, 29 Aug 2014 10:44:09 -0400
Message-Id: <5400ADD6020000780002F159@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 29 Aug 2014 15:44:06 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefan Bader" <stefan.bader@canonical.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Kees Cook" <keescook@chromium.org>,
        "David Vrabel" <david.vrabel@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Solved the Xen PV/KASLR riddle
References: <20140827204940.GA10556@laptop.dumpdata.com>
 <1409248903-19625-1-git-send-email-stefan.bader@canonical.com>
 <20140829140823.GF3609@laptop.dumpdata.com>
 <54008DDA.3040701@canonical.com>
In-Reply-To: <54008DDA.3040701@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 29.08.14 at 16:27, <stefan.bader@canonical.com> wrote:
> Sure. Btw, someone also contacted me saying they have the same problem 
> without
> changing the layout but having really big initrd (500M). While that feels 
> like
> it should be impossible (if the kernel+initrd+xen stuff has to fix the 512M
> kernel image size area then). But if it can happen, then surely it does 
> cause
> mappings to be where the module space starts then.

Since the initrd doesn't really need to be mapped into the (limited)
virtual address space a pv guest starts with, we specifically got

/*
 * Whether or not the guest can deal with being passed an initrd not
 * mapped through its initial page tables.
 */
#define XEN_ELFNOTE_MOD_START_PFN 16

to deal with that situation. The hypervisor side for Dom0 is in place,
and the kernel side works in our (classic) kernels. Whether it got
implemented for DomU meanwhile I don't know; I'm pretty certain
pv-ops kernels don't support it so far.

Jan

