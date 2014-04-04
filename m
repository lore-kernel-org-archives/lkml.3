Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaDDR2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:28:50 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59170 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaDDR2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:28:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAGdX0WGcx3aF6Uhsh=K2bG5CDD5iNqCyPUcf=RZWHsDehmE-qQ@mail.gmail.com>
References: <CAGdX0WEeZJ9hxq1y-gmGC=kdtU0ecLbs5gVYb_8ZE6sOW_PPvg@mail.gmail.com>
	<CAMEtUuyQZo6fSMTZ5XKPfPBdjR13916Rd3=z5dip3N_WOzvr6Q@mail.gmail.com>
	<CAGdX0WFm2wccs30q1=eduLdzjAjfxz-6oL-zGvumY6BigQ-a4g@mail.gmail.com>
	<20140404074800.GD1637@gmail.com>
	<CAGdX0WGcx3aF6Uhsh=K2bG5CDD5iNqCyPUcf=RZWHsDehmE-qQ@mail.gmail.com>
Date: Fri, 4 Apr 2014 10:28:43 -0700
Message-ID: <CAMEtUuxuTXo9Q-KMvZsH96Uzt5VsCLh1wHGtwn+k_P4iM8FTaw@mail.gmail.com>
Subject: Re: ktap and ebpf integration
From: Alexei Starovoitov <ast@plumgrid.com>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg KH <gregkh@linuxfoundation.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 7:20 AM, Andi Kleen <andi@firstfloor.org> wrote:

> BTW I agree that EBPF won't work for ktap. The models
> (static vs dynamic typing etc.) are just too different.

If you meant 'static vs dynamic safety checking' then yes.
This is a main difference between bpf and ktap approach to safety.
bpf engine and checker are disjoint.
Interpreter is dumb and just executes instructions.
ktap interpreter has to do all sorts of checking, since it cannot
trust instructions it sees.
In this sense, loops are not supported by ibpf today, since they
require run-time checks. I can think of a way to add such
support, but rather not. Such 'anti-feature' is not needed.

'ktap syntax' from user space point of view, can use ibpf as-is.
Show me the script and I can show how ibpf can run it.
