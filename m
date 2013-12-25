Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3LYOol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 09:44:41 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:50205 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3LYOoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 09:44:39 -0500
MIME-Version: 1.0
In-Reply-To: <52B9AF0A.3030806@hitachi.com>
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
	<20131219090409.14309.25677.stgit@kbuild-fedora.novalocal>
	<CAGdX0WFKYHqXrVQ6LBw0YgH_H6cP=LZVCBe1iOvEXsHQPD8Zmg@mail.gmail.com>
	<52B3AD7D.2020104@hitachi.com>
	<CAGdX0WENxTPhFDtcEW6LFhk1SNZc6mEK+JsCDOJmfK8_PS1rxg@mail.gmail.com>
	<52B3CABE.1080903@hitachi.com>
	<CAGdX0WEev84sOyu-uzkDOmQFi_=mza7cPzyC0VkRZe0fD_1+jQ@mail.gmail.com>
	<52B40C00.2060401@hitachi.com>
	<CAGdX0WECaJBSX29-+fC=0XLJfAh0JvFyLTW2V8yM616L45iCQQ@mail.gmail.com>
	<52B8178F.5020607@hitachi.com>
	<CAGdX0WEZue1fBtHw058HAmuCktkM+jyKdPfn0ZM2=fNAPfcJwA@mail.gmail.com>
	<52B9468D.4060201@hitachi.com>
	<CAGdX0WH=QvXMUfSL7-eXHWLM7VLPDus2=jFGCyJcK6Px-t0bng@mail.gmail.com>
	<52B9AF0A.3030806@hitachi.com>
Date: Wed, 25 Dec 2013 22:44:38 +0800
Message-ID: <CAGdX0WGh5pD6fEoCRr-2bxC5rY_5ZKz1sCoZEdA0zarmwkabrw@mail.gmail.com>
Subject: Re: [PATCH -tip v6 06/22] [BUGFIX] x86: Prohibit probing on memcpy/memset
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 11:58 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2013/12/24 18:53), Jovi Zhangwei wrote:
>>>> Still no crash, use your kernel config.
>>>> memcpy and __memcpy have same address in /proc/kallsyms.
>>>>
>>>> Looks like a interesting problem.
>>>
>>> Agreed. In my case, those have same address, but only probing
>>> __memcpy caused a kernel crash. I'm not sure why, but it is
>>> safe to disable probing on it.
>>>
>> Shall we need dig further to address the root cause? IMO, the kprobe
>> should act same behavior when given same probe address, but it's look
>> so weird in your box. :)
>
> Hmm, right now, I tried it again and found the bug disappeared...
>
> I'm using the latest tip kernel for the test;
> 3ab838d7723e9fbfd49b2d395752bd68e1ef4b71
>
> Should I remove this patch until it happens again?
>
Yes, we can check the problem if it happens again in somewhere. :)

Thanks.

Jovi.
