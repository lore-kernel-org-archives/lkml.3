Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab3BRXnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 18:43:13 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:42952 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230Ab3BRXnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 18:43:11 -0500
Message-ID: <5122BC8A.6040503@suse.cz>
Date: Tue, 19 Feb 2013 00:43:06 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: bskeggs@redhat.com, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: WARNING: at drivers/gpu/drm/nouveau/core/core/mm.c:242
References: <5122021F.1060207@suse.cz> <20130218232335.GA9730@joi.lan>
In-Reply-To: <20130218232335.GA9730@joi.lan>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 12:23 AM, Marcin Slusarz wrote:
> On Mon, Feb 18, 2013 at 11:27:43AM +0100, Jiri Slaby wrote:
>> Hi,
>>
>> we have a report of WARNING from 3.7.6 in nouveau at
>> drivers/gpu/drm/nouveau/core/core/mm.c:242 here:
>> https://bugzilla.novell.com/show_bug.cgi?id=802347#c11
>>
>> There is an order 4 allocation failure in nouveau_drm_open ->
>> nouveau_vm_create, i.e. this one failed:
>> vm->pgt  = kcalloc(vm->lpde - vm->fpde + 1, sizeof(*vm->pgt), GFP_KERNEL);
>>
>> Then, on the error path in still in nouveau_drm_open, it is followed by
>> a call to nouveau_cli_destroy. But that one calls nouveau_vm_ref ->
>> nouveau_mm_fini -> nouveau_vm_del -> nouveau_mm_fini which triggers the
>> warning.
>>
>> Any ideas?
> 
> Crash/warning should be fixed by commit cfd376b6bfccf33782a0748a9c70f7f752f8b869
> "drm/nouveau/vm: fix memory corruption when pgt allocation fails".

Oh, thanks for the pointer. Could that bug cause real "memory
corruption"? As we're hunting one there...

Isn't this a stable-3.7 candidate?

> Tomorrow I'll post a patch for page allocation failure.

What do you mean -- what kind of patch?

-- 
js
suse labs
