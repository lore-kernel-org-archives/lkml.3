Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaDERvD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 13:51:03 -0400
Received: from one.firstfloor.org ([193.170.194.197]:56009 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaDERvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 13:51:02 -0400
Date: Sat, 5 Apr 2014 19:50:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg KH <gregkh@linuxfoundation.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ktap and ebpf integration
Message-ID: <20140405175059.GT22728@two.firstfloor.org>
References: <CAGdX0WEeZJ9hxq1y-gmGC=kdtU0ecLbs5gVYb_8ZE6sOW_PPvg@mail.gmail.com>
 <CAMEtUuyQZo6fSMTZ5XKPfPBdjR13916Rd3=z5dip3N_WOzvr6Q@mail.gmail.com>
 <CAGdX0WFm2wccs30q1=eduLdzjAjfxz-6oL-zGvumY6BigQ-a4g@mail.gmail.com>
 <20140404074800.GD1637@gmail.com>
 <CAGdX0WGcx3aF6Uhsh=K2bG5CDD5iNqCyPUcf=RZWHsDehmE-qQ@mail.gmail.com>
 <CAMEtUuxuTXo9Q-KMvZsH96Uzt5VsCLh1wHGtwn+k_P4iM8FTaw@mail.gmail.com>
 <CAGdX0WEbUszQv=xVK35aes=Qcw=D-0HztML0jBJsKy6hVCH8cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WEbUszQv=xVK35aes=Qcw=D-0HztML0jBJsKy6hVCH8cA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 4) var i = 0; trace *:* { i += 1}
> Assign global variable in here, there also can assign other
> value not 0, please show me how BPF do this.
> (See complex global usage example in samples/schedule/schedtimes.kp)

That's what I meant. BPF is essentially a statically typed
language. KTAP is dynamically typed. It's a very different
model.

Yes they are both Turing complete and likely could 
be somehow translated into each other, but would
it be efficient and simple? No.

[essentially it's the "UNCOL problem" -- see
http://en.wikipedia.org/wiki/UNCOL
One size doesn't fit all in immediate languages]

-Andi

