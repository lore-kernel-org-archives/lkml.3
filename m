Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777Ab3JQUnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:43:11 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:58323 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762532Ab3JQUnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:43:09 -0400
MIME-Version: 1.0
In-Reply-To: <20131017162029.002485b1@gandalf.local.home>
References: <525FD328.1040204@broadcom.com>
	<20131017144116.044f3aaf@gandalf.local.home>
	<52604373.5010907@broadcom.com>
	<20131017162029.002485b1@gandalf.local.home>
Date: Thu, 17 Oct 2013 16:43:08 -0400
X-Google-Sender-Auth: nex6CLhwbdwnn5zIs6X3L5BEOZA
Message-ID: <CAEKwDSAucy8NziB=mcem7we9vnGHe=cWt-4Q1X7+Vt5dokY19A@mail.gmail.com>
Subject: Re: trace-cmd problem with FC19
From: Bob Copeland <me@bobcopeland.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sorry, resent for the archives, I failed email]
On Thu, Oct 17, 2013 at 4:20 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 17 Oct 2013 22:07:15 +0200
> "Arend van Spriel" <arend@broadcom.com> wrote:
>
>
>> > Does recording other traces work? Or is it only spicific to this module?
>>
>> It seems a generic issue:
>>
>> $ sudo trace-cmd record -e ext4:* ls
>> /sys/kernel/debug/tracing/events/ext4/*/filter
>> systemd-private-6pVB5L        systemd-private-KdpFqS  trace.dat.cpu0  trace.dat.cpu2
>> systemd-private-9hedRD        trace.dat               trace.dat.cpu1  trace.dat.cpu3
>> trace-cmd: Interrupted system call
>>    recorder error in splice input
>> trace-cmd: Interrupted system call
>>    recorder error in splice input
>> trace-cmd: Interrupted system call
>>    recorder error in splice input

Perhaps this is an instance of this bug?

https://lkml.org/lkml/2013/5/31/426

tl;dr try with latest trace-cmd?  I hit the above myself.

-- 
Bob Copeland %% www.bobcopeland.com
