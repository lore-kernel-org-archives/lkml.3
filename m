Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbbAGAns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 19:43:48 -0500
Received: from ozlabs.org ([103.22.144.67]:37494 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbbAGAnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 19:43:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>
Cc: Oded Gabbay <oded.gabbay@amd.com>, Andi Kleen <ak@linux.intel.com>,
        Alex Deucher <alexdeucher@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Dana Elifaz <Dana.Elifaz@amd.com>, LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [PATCH] drm/radeon: Try to init amdkfd only if 64 bit kernel
In-Reply-To: <CAGXu5jJ71tM99uaRoq74AkcB5KhxsfBS3NyDuJ2rJncKmfCWwg@mail.gmail.com>
References: <1419246673-7222-1-git-send-email-oded.gabbay@amd.com> <CADnq5_MY3+4BdWzUYffTnRWF3J4Z7nb6zyrGZK4RNwVU3axvuw@mail.gmail.com> <20141222184940.GB17192@tassilo.jf.intel.com> <20141222190041.GC17192@tassilo.jf.intel.com> <54986EA2.106@amd.com> <874msmt1hi.fsf@rustcorp.com.au> <549A85DE.1040006@amd.com> <87r3v96ebd.fsf@rustcorp.com.au> <CAGXu5jJ71tM99uaRoq74AkcB5KhxsfBS3NyDuJ2rJncKmfCWwg@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 07 Jan 2015 09:28:31 +1030
Message-ID: <87mw5v4iug.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> On Sun, Jan 4, 2015 at 8:28 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Kees, as far as I can tell you need another 0-terminated vmlinux.relocs
>> section for weak symbols.  These should not be relocated if already 0.
>
> A few questions:
>
> Why doesn't this break on 32-bit without kASLR? 32-bit does relocation
> by default, even without CONFIG_RANDOMIZE_BASE.

Well, the offset was 0 until I removed CONFIG_HIBERNATE.

> Are there any symbols that are NULL that aren't weak? I'd expect all
> strong symbols to have non-zero offsets, but I must be
> misunderstanding something here.

I don't think there would be.  Anyway, you might be able to filter them
out in x86/tools/relocs itself.

Cheers,
Rusty.
