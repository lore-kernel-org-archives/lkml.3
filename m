Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaHaO7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 10:59:31 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:57125 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHaO73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 10:59:29 -0400
Date: Sun, 31 Aug 2014 16:59:21 +0200
From: Rabin Vincent <rabin@rab.in>
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 7/8] ARM: mm: allow non-text sections to be
 non-executable
Message-ID: <20140831145921.GA4931@dator>
References: <1407949593-16121-1-git-send-email-keescook@chromium.org>
 <1407949593-16121-8-git-send-email-keescook@chromium.org>
 <20140819123342.GJ23128@arm.com>
 <CAGXu5jLnXeavr4E4YF9jtB03iA-y4vLZjf83a8ABzUC-hdkz9w@mail.gmail.com>
 <20140826144303.GX23445@arm.com>
 <CAGXu5j+OnpaZAJRsSsR=iid8178p+4hR5xzrJ7N3F94DZ7DYMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+OnpaZAJRsSsR=iid8178p+4hR5xzrJ7N3F94DZ7DYMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 09:04:41AM -0700, Kees Cook wrote:
> On Tue, Aug 26, 2014 at 7:43 AM, Will Deacon <will.deacon@arm.com> wrote:
> > Hmm, so do you mandate that preemption is disabled during sections of code
> > where the permissions must be changed after boot? (e.g. ftrace patching)
> 
> I guess it's not enforced (how do I make sure preempt is off?), but
> it's only used during the ftrace patching. I'm open to suggestions! (I
> had avoided going the fixmap route since I would have expected that to
> be much slower.)

For ftrace patching this is called under stop_machine() so preemption is
already off there.
