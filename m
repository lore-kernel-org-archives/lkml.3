Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab3BRK1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:27:51 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:62381 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab3BRK1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:27:49 -0500
Message-ID: <5122021F.1060207@suse.cz>
Date: Mon, 18 Feb 2013 11:27:43 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>, bskeggs@redhat.com
CC: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: at drivers/gpu/drm/nouveau/core/core/mm.c:242
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we have a report of WARNING from 3.7.6 in nouveau at
drivers/gpu/drm/nouveau/core/core/mm.c:242 here:
https://bugzilla.novell.com/show_bug.cgi?id=802347#c11

There is an order 4 allocation failure in nouveau_drm_open ->
nouveau_vm_create, i.e. this one failed:
vm->pgt  = kcalloc(vm->lpde - vm->fpde + 1, sizeof(*vm->pgt), GFP_KERNEL);

Then, on the error path in still in nouveau_drm_open, it is followed by
a call to nouveau_cli_destroy. But that one calls nouveau_vm_ref ->
nouveau_mm_fini -> nouveau_vm_del -> nouveau_mm_fini which triggers the
warning.

Any ideas?

thanks,
-- 
js
suse labs
