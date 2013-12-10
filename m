Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab3LJTP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:15:58 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:54658 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3LJTP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:15:57 -0500
MIME-Version: 1.0
In-Reply-To: <52A766A4.7040202@zytor.com>
References: <CAMe9rOrKGSxr9X5txGq2Js0vGwXdwxPT+ip70-YZs-Wz-aPgQg@mail.gmail.com>
	<52A766A4.7040202@zytor.com>
Date: Tue, 10 Dec 2013 11:15:57 -0800
Message-ID: <CAMe9rOoU51t9KUYEYFCVZVwDLTuGWyd9_d97-pcsFrT_WcYS0w@mail.gmail.com>
Subject: Re: RFC: binutils PATCH: Set e_type to ET_EXEC for -pie -Ttext-segment=
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Binutils <binutils@sourceware.org>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 11:08 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/10/2013 04:20 AM, H.J. Lu wrote:
>> On Mon, Dec 9, 2013 at 8:57 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> Where do the _32 and _32S relocations come from?  Are we mixing multiple things inside -pie?
>>
>> They come from crt1.o and crtbegin.o.  -pie uses Scrt1.o and crtbeginS.o.
>>
>
> OK, so this is fundamentally an issue with the gcc wrapper... there
> isn't a way to get the relocatable crt files without telling the linker
> to link PIE (except perhaps using some -Wl option, maybe "-Wl,-no-pie"?)
>
> Either way, if the *only* goal is to get the file above a certain point,
> like 4 GiB, then there is no reason not to randomize upward.
>

I agree that kernel should load ET_DYN binary anywhere.  I will
change linker to set type to ET_EXEC if p_vaddr != 0.

-- 
H.J.
