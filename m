Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaETRZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:25:13 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:36576 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaETRZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:25:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140520172134.GJ2185@moon>
References: <cover.1400538962.git.luto@amacapital.net> <276b39b6b645fb11e345457b503f17b83c2c6fd0.1400538962.git.luto@amacapital.net>
 <20140520172134.GJ2185@moon>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 May 2014 10:24:49 -0700
Message-ID: <CALCETrWSgjc+iymPrvC9xiz1z4PqQS9e9F5mRLNnuabWTjQGQQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86,mm: Improve _install_special_mapping and fix x86
 vdso naming
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: X86 ML <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 10:21 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Mon, May 19, 2014 at 03:58:33PM -0700, Andy Lutomirski wrote:
>> Using arch_vma_name to give special mappings a name is awkward.  x86
>> currently implements it by comparing the start address of the vma to
>> the expected address of the vdso.  This requires tracking the start
>> address of special mappings and is probably buggy if a special vma
>> is split or moved.
>>
>> Improve _install_special_mapping to just name the vma directly.  Use
>> it to give the x86 vvar area a name, which should make CRIU's life
>> easier.
>>
>> As a side effect, the vvar area will show up in core dumps.  This
>> could be considered weird and is fixable.  Thoughts?
>>
>> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
>> Cc: Pavel Emelyanov <xemul@parallels.com>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>
> Hi Andy, thanks a lot for this! I must confess I don't yet know how
> would we deal with compat tasks but this is 'must have' mark which
> allow us to detect vvar area!

Out of curiosity, how does CRIU currently handle checkpointing a
restored task?  In current kernels, the "[vdso]" name in maps goes
away after mremapping the vdso.

I suspect that you'll need kernel changes for compat tasks, since I
think that mremapping the vdso on any reasonably modern hardware in a
32-bit task will cause sigreturn to blow up.  This could be fixed by
making mremap magical, although adding a new prctl or arch_prctl to
reliably move the vdso might be a better bet.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
