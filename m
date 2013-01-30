Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab3A3R2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:28:07 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:54981 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab3A3R2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:28:04 -0500
MIME-Version: 1.0
In-Reply-To: <20130130034204.GB30965@pd.tnic>
References: <20130129202848.GE25415@pd.tnic> <CAErSpo4v473sXvmv3gqkftkiFZtz+gYgd1yzWae=nLJjwJPBug@mail.gmail.com>
 <20130130034204.GB30965@pd.tnic>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 30 Jan 2013 10:27:42 -0700
Message-ID: <CAErSpo47BvEsDC1o_kYDeyd6j3VUoWHwSMYPyLpZYB1H-sL=7A@mail.gmail.com>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
To: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 8:42 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Jan 29, 2013 at 02:32:56PM -0700, Bjorn Helgaas wrote:
>> Konstantin has some fixes for an e1000e power management issue related
>> to suspend/resume that he observed on an x220. He didn't see an NMI,
>> and apparently his problem has been around for a long time,
>
> Yeah, this is one of those issues you don't see *every* s/r cycle and
> besides, I just got this box and haven't run 3.{6,7} on it yet (maybe
> never will :-)).
>
>> so no idea whether it could be related. I just noticed the conjunction
>> of thinkpad/e1000e/resume/power saving in both reports.
>>
>> https://lkml.org/lkml/2013/1/18/147
>
> Yes, thanks Bjorn, that was a good suggestion. Btw, from reading the
> thread, those patches still need cooking a bit more, AFAICR people's
> objections/comments. Or should I go ahead and test them?

You're right, I don't think we're quite ready to merge those patches.
But if your NMI is easy to reproduce, it might be worth removing
e1000e altogether to see if it still happens.  I noticed in your
original log that the NMI occurred 5 seconds after the e1000e message,
and I could imagine some CPU or PCI response timeout being 5 seconds.

> It's just that I'm overly cautious every time I hear e1000e is involved:
>
> www.linux-magazine.com/content/download/62169/484085/file/Security_Lessons_Ftrace.pdf

Thanks for the pointer, that was an interesting read :)

Bjorn
