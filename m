Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbaIEIAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:00:54 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:63226 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181AbaIEIAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:00:52 -0400
MIME-Version: 1.0
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E9826A6@SHSMSX101.ccr.corp.intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
	<1409161588-19417-4-git-send-email-alvin.chen@intel.com>
	<CACRpkdZJSf+EfYN=hHxRnpjQZGuqroBL0c+08Ng=dRkS0GZySA@mail.gmail.com>
	<4656BEB6164FC34F8171C6538F1A595B2E9826A6@SHSMSX101.ccr.corp.intel.com>
Date: Fri, 5 Sep 2014 10:00:51 +0200
Message-ID: <CACRpkdYZ0W4+iGyP5bbARAAfrqcrG77PVCHKcGhnBXvpCHoqxw@mail.gmail.com>
Subject: Re: [PATCH 3/3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
From: Linus Walleij <linus.walleij@linaro.org>
To: "Chen, Alvin" <alvin.chen@intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 4:09 AM, Chen, Alvin <alvin.chen@intel.com> wrote:

>> > +       unsigned long data;
>> > +       unsigned long dir;
>> > +       unsigned long int_en;
>> > +       unsigned long int_mask;
>> > +       unsigned long int_type;
>> > +       unsigned long int_pol;
>> > +       unsigned long int_deb;
>> > +} saved_regs;
>>
>> Singleton huh?
>>
>> Insert this into the dynamically allocated per-port or chip struct instead.
>>
> How about the following?
>
> static struct dwapb_context {
>         u32 data[DWAPB_MAX_PORTS];
>         u32 dir[DWAPB_MAX_PORTS];
>         u32 ext[DWAPB_MAX_PORTS];
>         u32 int_en;
>         u32 int_mask;
>         u32 int_type;
>         u32 int_pol;
>         u32 int_deb;
> } dwapb_context;

NO because this is still a singleton variable. Put it into the
dynamically allocated structs.

> Comparing to allocate for each port
> dynamically, it is more directly and easy to understand.

No, I disagree. The overall design pattern in the kernel is to
allocate all state containers dynamically.

Yours,
Linus Walleij
