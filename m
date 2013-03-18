Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab3CRNSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:18:14 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:45880 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3CRNSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:18:12 -0400
MIME-Version: 1.0
In-Reply-To: <1363612263.22553.12.camel@laptop>
References: <20130318124847.GA2491@quad>
	<1363611569.22553.10.camel@laptop>
	<CABPqkBRGutLBC+mO+F8fH5F-Yoe1NL8e_=yF9boxA28jNLO56g@mail.gmail.com>
	<1363612263.22553.12.camel@laptop>
Date: Mon, 18 Mar 2013 14:18:12 +0100
Message-ID: <CABPqkBRM7b-ONg4fuRuUF-p-mJZNzXA69_VQpASGJBgWTCCbow@mail.gmail.com>
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

On Mon, Mar 18, 2013 at 2:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2013-03-18 at 14:03 +0100, Stephane Eranian wrote:
>> On Mon, Mar 18, 2013 at 1:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, 2013-03-18 at 13:48 +0100, Stephane Eranian wrote:
>> >>         if (!rb->writable)
>> >> -               return true;
>> >> +               return false;
>> >
>> >
>> > writable means user writable (VM_WRITE); the difference is that a
>> > !VM_WRITE buffer will simply over-write its own tail whereas a VM_WRITE
>> > buffer will drop events.
>> >
>> > So returning true for !VM_WRITE makes sense, there's always space.
>> >
>> Ok, that was not so clear to me. I think this if() statment deserves a comment.
>> I will add that in V2.
>
> Thanks; I suppose renaming the entire ->writable thing might be better
> though. Something like ->overwrite or so.
>
Yes. And if you do this you invert the logic of the field.
overwrite=1 -> !VM_WRITE
overwrite=0 -> VM_WRITE
