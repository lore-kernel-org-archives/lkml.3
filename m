Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaFLSmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:42:55 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:53508 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaFLSmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:42:53 -0400
MIME-Version: 1.0
In-Reply-To: <5399F445.6060200@linux.intel.com>
References: <CAKx2Y1kBy-mrxm+1u88XVL2Z7gYKQe5U-EG2SBTzNCRAs_UVVw@mail.gmail.com>
 <CALCETrWMBAxz9yn4MMugjZGC_Dsi2p855+e99Qhr0Ab+OaGRXw@mail.gmail.com>
 <CALCETrWTx5j9mx-CeXJDUAXh8KqVhGqBK+gpOPgJS1hOgH5tmg@mail.gmail.com> <5399F445.6060200@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Jun 2014 11:42:32 -0700
Message-ID: <CALCETrV96Ry5f_RDvXfZ98ay9qLZw0-8H5LZ8NrPiS92WDWTmA@mail.gmail.com>
Subject: Re: Segmentation fault on all golang executables
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Kui Zhang <kuizhang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 11:41 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 06/12/2014 11:38 AM, Andy Lutomirski wrote:
>>>
>>> 2. Write a dummy section table that contains a single empty section of
>>> type SHT_DYNSYM.  Hopefully the Go runtime will then get far enough to
>>> fail cleanly.  And they can go and write a real ELF parser or copy my
>>> reference parser correctly.  (hpa, can you apply my patches to make
>>> the reference parser 32-bit clean?)
>>
>
> Could you resend it please?

Yes.  I'll send the whole series.

>
>> Sigh.
>>
>> See attached.  It seems to work for me.  Can you test it?  It'll hurt
>> performance for Go programs, but I don't feel too bad about that.
>>
>
> If Google fixes Go, will that address the performance problem?

Yes.

Note that my hack will build a buggy vdso on big-endian hosts.  Is
there a way to convert host -> BE yet?

--Andy
