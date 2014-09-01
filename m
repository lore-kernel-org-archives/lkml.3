Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaIAPbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:31:13 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40316 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbaIAPbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:31:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAJhHMCBOeLK-Z_96V_aAWBikS6tjrdYfj6_0w-9kSzQb=UJZsw@mail.gmail.com>
References: <1409369788-22563-1-git-send-email-bobby.prani@gmail.com>
	<CAMuHMdV_naTfQOLwOshWq1Q15kSE39a8GWChsjt3RrWRcd6peg@mail.gmail.com>
	<CAJhHMCDaSAzU3zvhY2FRFoBaQH4oQBTsUsYMU6pvBbCXydROZQ@mail.gmail.com>
	<CANq1E4SCnDjN5yetrgtaRNdvDr7xqGOm1BXz7dbGvX3mnsm-MA@mail.gmail.com>
	<54036090.1050104@gmail.com>
	<CANq1E4QbRLjCGr+PuHqKa6Kx_+4MTmbzd9V1RqrQFS3f5YoSag@mail.gmail.com>
	<CAJhHMCBOeLK-Z_96V_aAWBikS6tjrdYfj6_0w-9kSzQb=UJZsw@mail.gmail.com>
Date: Mon, 1 Sep 2014 17:31:09 +0200
Message-ID: <CANq1E4Sf-XMkODhxEM9Bacr_RBt8p_dHPyeyb7a70_VqrmwXeA@mail.gmail.com>
Subject: Re: [RFC PATCH] powerpc: Wire up three syscalls
From: David Herrmann <dh.herrmann@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anton Blanchard <anton@samba.org>, Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Sep 1, 2014 at 5:21 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> Hi David,
>
> On Mon, Sep 1, 2014 at 7:33 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>>
>> Nice catch. We changed 'flags' from u64 to "unsigned int" in the last
>> revision of the series. Patch looks good, but I'd prefer using
>> "unsigned int" as type, instead of __u32. Just to be consistent with
>> the syscall interface. The return type of F_GET_SEALS is actually
>> "int" and the MSB is reserved for signed error codes, so you can
>> savely use "int r = fcntl(fd, F_GET_SEALS, 0)" in
>> mfd_assert_get_seals().
>>
>
> OK. Should I send a new patch with these changes or do you have one
> line up already?

I'd appreciate if you can resend it.

Btw., the original patch (wire up syscalls) can be applied unchanged.

Thanks
David
