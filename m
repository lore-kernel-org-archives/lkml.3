Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3CFR0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:26:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45625 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab3CFR0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:26:33 -0500
Message-ID: <51377C3A.3030301@zytor.com>
Date: Wed, 06 Mar 2013 09:26:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Robin Holt <holt@sgi.com>, hpa@sgi.com,
        linux-kernel@vger.kernel.org, pjones@redhat.com
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11 elilo.efi
References: <20130228205206.GC3438@sgi.com> <512FC697.3090608@zytor.com> <20130228210910.GD3438@sgi.com> <512FC82B.40909@zytor.com> <CAE9FiQU3FBwEiC86N1RC8=aMdN09EbUmRcsWP0yof7bmxBhPew@mail.gmail.com> <512FE3AE.4070903@zytor.com> <20130305081519.GA19165@sgi.com> <9bcd6241-37fd-4ae9-a997-2a5da1eaf997@email.android.com> <CAE9FiQV2Wk+yiqR8FnNM_L-p1iQFxDwopRzFWTwm6VCkyrbuoQ@mail.gmail.com> <CA+5PVA4VRa7z10APcEaoebX3vwtbLzDLq1PAHmfaHBDqtZv=jw@mail.gmail.com>
In-Reply-To: <CA+5PVA4VRa7z10APcEaoebX3vwtbLzDLq1PAHmfaHBDqtZv=jw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 08:53 AM, Josh Boyer wrote:
> 
> I don't think this is limited to elilo.  I have a UEFI machine booting
> with grub2 that also fails to boot because of this patch.  I was in the
> middle of bisecting when I found this thread and if I revert 5dcd14ecd4
> the machine boots again.  Put that commit back in and it doesn't.  We've
> had three other reports in Fedora of similar cases.
> 
> I discussed this with Peter Jones this morning.  He was looking into what
> grub2 does for boot_params and it seems to be read-modify-write instead
> of clearing the whole thing.  (CC'd Peter now.)
> 
> The patch for elilo probably works, but if grub2 is hitting this then I'm
> curious if most bootloaders will.  I'll finish my bisect just to be extra
> sure, but something probably needs to be done in a more generic fashion
> here.
> 

Come to think about it...

The EFI field actually has a magic, unless just about all the rest of
them, so clearing it is probabilistically redundant; in other words we
almost certainly should exclude it from the clearing, unconditionally.

Does the "elilo" patch made unconditional work for you?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

