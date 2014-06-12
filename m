Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaFLTLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:11:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36402 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaFLTLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:11:50 -0400
Message-ID: <5399FB68.2000507@zytor.com>
Date: Thu, 12 Jun 2014 12:11:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Kui Zhang <kuizhang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Segmentation fault on all golang executables
References: <CAKx2Y1kBy-mrxm+1u88XVL2Z7gYKQe5U-EG2SBTzNCRAs_UVVw@mail.gmail.com> <CALCETrWMBAxz9yn4MMugjZGC_Dsi2p855+e99Qhr0Ab+OaGRXw@mail.gmail.com> <CALCETrWTx5j9mx-CeXJDUAXh8KqVhGqBK+gpOPgJS1hOgH5tmg@mail.gmail.com> <5399F445.6060200@linux.intel.com> <CALCETrV96Ry5f_RDvXfZ98ay9qLZw0-8H5LZ8NrPiS92WDWTmA@mail.gmail.com> <5399F616.2040809@linux.intel.com> <CALCETrWyC5B0EgdbxKr_VYN+bARGy55E_p2ppk-gW5sLc5jHWg@mail.gmail.com>
In-Reply-To: <CALCETrWyC5B0EgdbxKr_VYN+bARGy55E_p2ppk-gW5sLc5jHWg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 11:51 AM, Andy Lutomirski wrote:
> On Thu, Jun 12, 2014 at 11:48 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>> On 06/12/2014 11:42 AM, Andy Lutomirski wrote:
>>>
>>> Note that my hack will build a buggy vdso on big-endian hosts.  Is
>>> there a way to convert host -> BE yet?
>>>
>>
>> Yes, use <tools/be_byteshift.h>.
> 
> What should I rebase on for that?  And wasn't there some header that
> was supposed to choose the right include file given the host runtime?
> 
> Also, I meant host -> LE, of course, but that should be trivial.
> 

No need to rebase.  My patchset proposes replacing
<tools/be_byteshift.h> and <tools/le_byteshift.h> by a unified
<tools/unaligned.h> but that is not important for this purpose.

host -> LE uses <tools/le_byteshift.h> which is already in use by
vdso2c.  Use put_unaligned_leXX().

	-hpa


