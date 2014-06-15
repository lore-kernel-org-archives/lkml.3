Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaFOKKJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 06:10:09 -0400
Received: from plane.gmane.org ([80.91.229.3]:38093 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaFOKKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 06:10:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stijn Volckaert <svolckae@elis.ugent.be>
Subject: Re: vdso feature requests from the Go people
Date: Sun, 15 Jun 2014 11:39:14 +0200
Message-ID: <lnjpkl$2iq$1@ger.gmane.org>
References: <CALCETrVNiSUHok1xCfy9CMe=kDYsPy3i_NXm0_gcO1ckb9wdeQ@mail.gmail.com> <539A890A.5090206@zytor.com> <CALCETrX9Og2LR3d8HZrcn4uGAgLfxbv51LK4Tsq-gDZKGpsjYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78-22-128-128.access.telenet.be
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
In-Reply-To: <CALCETrX9Og2LR3d8HZrcn4uGAgLfxbv51LK4Tsq-gDZKGpsjYw@mail.gmail.com>
X-Antivirus: avast! (VPS 140614-1, 14/06/2014), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski schreef op 13/06/2014 7:23:
> On Thu, Jun 12, 2014 at 10:15 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 06/12/2014 09:36 PM, Andy Lutomirski wrote:
>>>
>>> If we were to implement both, maybe we'd actually want to provide
>>> something like:
>>>
>>> struct vdso_entry {
>>>    unsigned long vdso_entry_struct_size;  /* so we can add fields later on */
>>>    void *func;
>>>    unsigned int max_stack;  /* zero if not known */
>>> };
>>>
>>
>> How different is this really from the .dynsym table -- other than that
>> you have to find the latter via the dynamic segment?
>>
>> The hash part is just to speed up lookup...
>
> As far as I know, there's no reliable way to just read the dynsym
> table -- the thing doesn't have a specified length, which is what
> broke Go in the first place.
>
> Parsing the ELF dynamic tables is kind of annoyingly complicated, and
> understanding the format is a real PITA -- the documentation I've been
> able to find is outright terrible.
>
> --Andy
>

Why does it need a specified length? It's pretty easy to find, the 
entries have a fixed length and the last entry in the table is NULLed 
out (i.e. the d_tag is DT_NULL).

Just look for the PT_DYNAMIC segment in the program headers and iterate 
over the fixed length Elf_Dyn entries to find what you're looking for.

As for ELF documentation, I've never had any problems understanding the
official specification:
http://refspecs.linuxbase.org/elf/elf.pdf

--Stijn

