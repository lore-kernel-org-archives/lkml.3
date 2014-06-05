Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaFEQoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:44:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50439 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbaFEQoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:44:12 -0400
Message-ID: <53909E46.4020904@zytor.com>
Date: Thu, 05 Jun 2014 09:43:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Andy Lutomirski <luto@amacapital.net>,
        Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
References: <20140605071805.GA16647@pd.tnic> <CAL01qpuj6jvH4XLvhHAszbqmSPXfW=VOdv+TqMwBuDnArL=ofw@mail.gmail.com> <20140605090206.GA16642@pd.tnic> <CALCETrU2TZhxOZyCvBd1nLDiU4ceiSx_Sd2bsDUCX5arOFidBg@mail.gmail.com> <20140605155307.GD16642@pd.tnic> <CALCETrVqqgExhuAYawh_7tc8-Nm8GGiMxmtw25mLFoxru-odZg@mail.gmail.com> <20140605160842.GE16642@pd.tnic> <CALCETrUors-39hUxS9Bg-dh+DzMcmPOs=6t998sbCVjqXYgyug@mail.gmail.com> <20140605161834.GF16642@pd.tnic> <53909B50.50407@zytor.com> <20140605163711.GG16642@pd.tnic>
In-Reply-To: <20140605163711.GG16642@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 09:37 AM, Borislav Petkov wrote:
> On Thu, Jun 05, 2014 at 09:31:12AM -0700, H. Peter Anvin wrote:
>> The bottom line is that we can't call EFI from a context where we can't
>> use the FPU.  Or specifically, we can't then resume execution.
> 
> Can't we allocate a save-state area, stash the state there and let EFI
> scribble over it? When EFI returns, we scribble over it back assuming it
> has done the saving/restoring on its own.

I'm sorry I don't follow.

	-hpa

