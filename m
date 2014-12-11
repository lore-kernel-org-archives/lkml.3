Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbaLKAZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:25:12 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:47507 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125AbaLKAZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:25:08 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8MBb+iw3KJz5EgX-DLBHGWANUSVFP2bQe2_U4kqCfM-wzH8Q@mail.gmail.com>
References: <20141124205441.GW5050@linux.vnet.ibm.com> <CALCETrXBofV3oxDwK4MiSvFQcX3yxX_sL_KY63EZ8DgS8LnJSg@mail.gmail.com>
 <20141124213501.GX5050@linux.vnet.ibm.com> <20141124223407.GB8512@linux.vnet.ibm.com>
 <CALCETrUA+z5z6bnOw63-EUiFD4WQtBXm1TE2DSRj3uG+d_k-bQ@mail.gmail.com>
 <20141124225754.GY5050@linux.vnet.ibm.com> <20141124233101.GA2819@linux.vnet.ibm.com>
 <CALCETrV37kqC658AzBHZ5z_vH2b_1T821q5EfbMcS9Ecpj8EEw@mail.gmail.com>
 <20141124235058.GZ5050@linux.vnet.ibm.com> <CALCETrUFwyBYFWZi4JC1-HftmUumLr+bB1kh8EW6LViN+G+j+g@mail.gmail.com>
 <20141125185803.GC3938@pd.tnic> <CA+8MBb+iw3KJz5EgX-DLBHGWANUSVFP2bQe2_U4kqCfM-wzH8Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 10 Dec 2014 16:24:46 -0800
Message-ID: <CALCETrWFBEvL4CSD+cZ0inMcvv09rLJi4Wpf4gLz5fvsGcV-wQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST context
To: Tony Luck <tony.luck@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 4:22 PM, Tony Luck <tony.luck@gmail.com> wrote:
> On Tue, Nov 25, 2014 at 10:58 AM, Borislav Petkov <bp@alien8.de> wrote:
>> On Mon, Nov 24, 2014 at 03:52:10PM -0800, Andy Lutomirski wrote:
>>> Dunno. Tony and Borislav -- when do you want the IST stack switching
>>> stuff?
>>
>> I'd leave that up to Tony and his testbench. I mean, we can hammer on
>> it as much as we can and it can pass all testing locally but the real
>> fun starts once it hits upstream and for that it doesn't matter which
>> release... IMHO.
>
> So what was the net result of all the mode/RCU discussions?
>
> Do I need some extra magic incantations in the final version
> of do_machine_check() beyond what was in this patch:
>
>   https://lkml.kernel.org/r/546d169211835aded@agluck-desk.sc.intel.com
>
> to make everything happy?
>

I think you need ist_begin_non_atomic() before local_irq_enable() and
ist_end_non_atomic() after local_irq_disable().  Otherwise it should
be good.

--Andy

> -Tony



-- 
Andy Lutomirski
AMA Capital Management, LLC
