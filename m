Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3BSHHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 02:07:44 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55026 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab3BSHHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 02:07:42 -0500
Date: Tue, 19 Feb 2013 08:07:44 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: bskeggs@redhat.com, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: WARNING: at drivers/gpu/drm/nouveau/core/core/mm.c:242
Message-ID: <20130219070744.GA3032@joi.lan>
References: <5122021F.1060207@suse.cz>
 <20130218232335.GA9730@joi.lan>
 <5122BC8A.6040503@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5122BC8A.6040503@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 12:43:06AM +0100, Jiri Slaby wrote:
> On 02/19/2013 12:23 AM, Marcin Slusarz wrote:
> > On Mon, Feb 18, 2013 at 11:27:43AM +0100, Jiri Slaby wrote:
> >> Hi,
> >>
> >> we have a report of WARNING from 3.7.6 in nouveau at
> >> drivers/gpu/drm/nouveau/core/core/mm.c:242 here:
> >> https://bugzilla.novell.com/show_bug.cgi?id=802347#c11
> >>
> >> There is an order 4 allocation failure in nouveau_drm_open ->
> >> nouveau_vm_create, i.e. this one failed:
> >> vm->pgt  = kcalloc(vm->lpde - vm->fpde + 1, sizeof(*vm->pgt), GFP_KERNEL);
> >>
> >> Then, on the error path in still in nouveau_drm_open, it is followed by
> >> a call to nouveau_cli_destroy. But that one calls nouveau_vm_ref ->
> >> nouveau_mm_fini -> nouveau_vm_del -> nouveau_mm_fini which triggers the
> >> warning.
> >>
> >> Any ideas?
> > 
> > Crash/warning should be fixed by commit cfd376b6bfccf33782a0748a9c70f7f752f8b869
> > "drm/nouveau/vm: fix memory corruption when pgt allocation fails".
> 
> Oh, thanks for the pointer. Could that bug cause real "memory
> corruption"? As we're hunting one there...

Yes.

> Isn't this a stable-3.7 candidate?

Should have been :/.

> > Tomorrow I'll post a patch for page allocation failure.
> 
> What do you mean -- what kind of patch?

A patch which will change pgt allocation to use vmalloc.

Marcin
