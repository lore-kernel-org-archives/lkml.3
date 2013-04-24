Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3DXH7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:59:48 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:63268 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3DXH7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:59:46 -0400
MIME-Version: 1.0
In-Reply-To: <51778C3B.7010501@st.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
	<CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com>
	<CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A63B4@DLEE11.ent.ti.com>
	<51778C3B.7010501@st.com>
Date: Wed, 24 Apr 2013 13:29:46 +0530
Message-ID: <CAJe_ZhfF93wWuUBktnt8eBnYR6fauUngViALuopfeiQ7P_N1uA@mail.gmail.com>
Subject: Re: [PATCHv3 00/14] drivers: mailbox: framework creation
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Loic PALLARDY <loic.pallardy@st.com>
Cc: "Anna, Suman" <s-anna@ti.com>,
        "Ohad Ben-Cohen (ohad@wizery.com)" <ohad@wizery.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Andy Green (andy.green@linaro.org)" <andy.green@linaro.org>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Loic,

On 24 April 2013 13:09, Loic PALLARDY <loic.pallardy@st.com> wrote:
> Hi Jassi, Suman,
>
> Yes, the xxx_no_irq API has been introduced to answer some STE
> requirements. It must be possible to send some message under atomic
> context for different reasons (latency, during idle/suspend procedures...).
> This is not the best way to do, but the goal was to preserve TI legacy
> in a first step. As explained by Suman, this patch series is coming from
> the original TI mailbox framework and is modified step by step to fit
> with all platforms.
>
IMHO a better way is to introduce a clean generically designed API and
convert the existing drivers one at time. Let the TI drivers work as
such for a while until someone converts them to the common API.
Cloning and then complete organ transplantation seems a very
inefficient way to have something new ;)

>>>
>>> (d) The 'struct mailbox_msg' should be just an opaque void* - the client/protocol
>>> driver typecasts to void* the IPC controller specific message structure. API
>>> shouldn't aim the impossible of providing a generic message format.
>>
>> The size parameter would still be needed. Depending on the h/w, it can be just an u32 or a series of bytes, and even in the latter case, it is not guaranteed that all messages transmitted will occupy the entire h/w shared memory data packet. I can see the current header field getting absorbed into the opaque void * structure for the ST mailbox driver. The size and ptr together provide a very generic message format.
> That's something we discussed with Suman. The mailbox framework should
> be independent from message format. Since mailbox could be base don a
> shared mem or an hw fifo, message size is mandatory to transmit the
> right number of data.
>
I too believe the "mailbox framework should be independent from
message format" but _also_ that .size doesn't have to be a part of the
standard format.
Maybe it will help if I know what you guys mean by "shared mem" or an
"hw fifo" mailbox?

Thanks
-Jassi
