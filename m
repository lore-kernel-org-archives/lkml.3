Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaKFQcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:32:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaKFQcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:32:43 -0500
Date: Thu, 6 Nov 2014 10:32:37 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Seth Jennings <sjenning@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141106163237.GA4075@treble.hsd1.ky.comcast.net>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411061607250.29198@pobox.suse.cz>
 <20141106162049.GA14689@cerebellum.variantweb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141106162049.GA14689@cerebellum.variantweb.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:20:49AM -0600, Seth Jennings wrote:
> On Thu, Nov 06, 2014 at 04:11:37PM +0100, Jiri Kosina wrote:
> > On Thu, 6 Nov 2014, Seth Jennings wrote:
> > > +/****************************************
> > > + * dynamic relocations (load-time linker)
> > > + ****************************************/
> > > +
> > > +/*
> > > + * external symbols are located outside the parent object (where the parent
> > > + * object is either vmlinux or the kmod being patched).
> > > + */
> > 
> > I have no ideas what dynrela is, and quickly reading the source doesn't 
> > really help too much.
> > 
> > Could you please provide some explanation / pointer to some documentation, 
> > explaining what exactly it is, and why should it be part of the common 
> > infrastructure?
> 
> Yes, I should explain it.
> 
> This is something that is currently only used in the kpatch approach.
> It allows the patching core to do dynamic relocations on the new
> function code, similar to what the kernel module linker does, but this
> works for non-exported symbols as well.
> 
> This is so the patch module doesn't have to do a kallsyms lookup on
> every non-exported symbol that the new functions use.
> 
> The fields of the dynrela structure are those of a normal ELF rela
> entry, except for the "external" field, which conveys information about
> where the core module should go looking for the symbol referenced in the
> dynrela entry.

BTW, use of the dynrelas is optional, but highly recommended.  The
kGraft approach of manually doing a kallsyms lookup for each
non-exported symbol is inherently dangerous because of duplicate
symbols.

-- 
Josh
