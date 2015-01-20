Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbbATJqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:46:10 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:34672 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbATJqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:46:08 -0500
Date: Tue, 20 Jan 2015 09:45:57 +0000
From: Lee Jones <lee.jones@linaro.org>
To: =?utf-8?B?5pWs6ZSQ?= <micky_ching@realsil.com.cn>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        =?utf-8?B?546L54Kc?= <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 06/10] mfd: rtsx: update phy register
Message-ID: <20150120094557.GL5767@x1>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <38141c346f29fcf48b4dc168c1841c8732c70b4c.1421320541.git.micky_ching@realsil.com.cn>
 <20150118122947.GM3574@x1>
 <54BC6426.40902@realsil.com.cn>
 <20150119074715.GO3574@x1>
 <54BDB860.9080704@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BDB860.9080704@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, 敬锐 wrote:
> On 01/19/2015 03:47 PM, Lee Jones wrote:
> > On Mon, 19 Jan 2015, 敬锐 wrote:
> >> >On 01/18/2015 08:29 PM, Lee Jones wrote:
> >>> > >On Thu, 15 Jan 2015,micky_ching@realsil.com.cn  wrote:
> >>> > >
> >>>> > >>From: Micky Ching<micky_ching@realsil.com.cn>
> >>>> > >>
> >>>> > >>update phy register value and using direct value instead of macros.
> >>>> > >>It is much easier to debug using constant value than a lot of macros.
> >>>> > >>We usually need compare the value directly to check the configure.
> >>> > >NACK.  This is the opposite of what I would like to see.
> >>> > >
> >> >When we debug, we usually need to compare the value provided from hardware,
> >> >of course we can compare by print them to kernel log. but I think it more
> >> >convenient from source code. And we only set phy register when
> >> >initialize chip,
> >> >so the value will not scattered everywhere, we will not benefit from macros.
> >> >
> >> >if we want to know the meaning of setting, we can look at the register
> >> >define.
> > This is not acceptable and is the complete opposite of what we're
> > trying to achieve.  I promote readability (by humans) as one of the
> > highest priorities when writing code.  0xFE6C is far from readable.
> >
> Because the truly thing we concerned is the address and value, not
> a lot of macros. 0xFE6C is a magic number, but a lot of macros
> even hide the magic number we curious. To verify if the source
> code is right, we only need to compare the value, if too much macros
> joined together, the work is boring and easy to inject errors.

I completely disagree and think the converse to be true.  It's _much_
easier to get the magic number incorrect.

> I hate magic number too, but in this case using magic number
> is deserved for correctness.
> 
> Two method can help enhance readability.
> (1). define register address and values
> If we want to know what the bit field means, we can jump to the register
> define. This is very easy by tag system.
> eg.
> rtsx_pci_write_phy_register(pcr, PHY_BPCR, 0x05C0);
> we can jump to PHY_BPCR to see bit-field define.
>
> (2). add comment for magic number.
> I don't like comment.
> 
> If you still like macro list, I will update the register next patch.

Defining register values and bit fields is the _correct_ way to do
this.  Using magic numbers is the _wrong_ way.

I'm sorry Micky, but I am not moving on this.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
