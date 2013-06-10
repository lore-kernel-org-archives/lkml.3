Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3FJVn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:43:29 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:41970 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab3FJVnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:43:21 -0400
Message-ID: <51B64877.4040908@schinagl.nl>
Date: Mon, 10 Jun 2013 23:43:19 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130528 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: maxime.ripard@free-electrons.com, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
References: <1370185130-15332-1-git-send-email-oliver+list@schinagl.nl> <1370185130-15332-2-git-send-email-oliver+list@schinagl.nl> <CAHp75Vdqc9xiPBvQUB3Hfb4EBFUsoVxyuH8MK=9spJ4+rieoDQ@mail.gmail.com>
In-Reply-To: <CAHp75Vdqc9xiPBvQUB3Hfb4EBFUsoVxyuH8MK=9spJ4+rieoDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/13 21:16, Andy Shevchenko wrote:

Thank you andy for your review, I do have a few questions/comments if 
you don't mind.
> On Sun, Jun 2, 2013 at 5:58 PM, Oliver Schinagl <oliver+list@schinagl.nl> wrote:
>> From: Oliver Schinagl <oliver@schinagl.nl>
<snip>
>> +       if (likely((SID_SIZE))) {
>
> Extra braces.
> Use antipattern here.

While I accidentally dropped the pointer here, sorry for the confusion, 
what is antipattern? I have asked around and nobody really knew.

Wikipedia mentions it as a software development thing, but you make it 
sound like it is some sort of tool?

<snip>
>> +       if (unlikely(!pdev->dev.of_node)) {
>> +               dev_err(dev, "No devicetree data available\n");
>> +               ret = -EFAULT;
>> +               goto exit;
>
> Plain return here and in entire function where it applies.
Why? I know there's conflicting preferences here. The general consensus 
seems, don't return mid function if you don't absolutely have to. Yet, 
you make it sound, just return wherever. I take it that really is just a 
preference? I think i see both constructs throughout the kernel. So one 
review prefers the one method, the next the other?
<snip>
>> +
>> +       ret = device_create_bin_file(dev, &sid_bin_attr);
>> +       if (unlikely(ret)) {
>
> Any benifit of (un)likely in probe()?
Does it hurt however in any way though? It's just a compiler 
optimization isn't it.

<snip>
>
> --
> With Best Regards,
> Andy Shevchenko
>
Thank you for your time, it is much appreciated :)

Oliver
