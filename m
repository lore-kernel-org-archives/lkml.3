Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3CRNDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:03:24 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:38802 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3CRNDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:03:23 -0400
MIME-Version: 1.0
In-Reply-To: <1363611569.22553.10.camel@laptop>
References: <20130318124847.GA2491@quad>
	<1363611569.22553.10.camel@laptop>
Date: Mon, 18 Mar 2013 14:03:22 +0100
Message-ID: <CABPqkBRGutLBC+mO+F8fH5F-Yoe1NL8e_=yF9boxA28jNLO56g@mail.gmail.com>
Subject: Re: [PATCH] perf: fix ring_buffer perf_output_space() boundary calculation
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 1:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2013-03-18 at 13:48 +0100, Stephane Eranian wrote:
>>         if (!rb->writable)
>> -               return true;
>> +               return false;
>
>
> writable means user writable (VM_WRITE); the difference is that a
> !VM_WRITE buffer will simply over-write its own tail whereas a VM_WRITE
> buffer will drop events.
>
> So returning true for !VM_WRITE makes sense, there's always space.
>
Ok, that was not so clear to me. I think this if() statment deserves a comment.
I will add that in V2.
