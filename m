Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765253Ab3DDW0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 18:26:45 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61137 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765206Ab3DDW0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 18:26:44 -0400
Message-ID: <515DFE1F.3010106@linaro.org>
Date: Thu, 04 Apr 2013 15:26:39 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: David Ahern <dsahern@gmail.com>, Pawel Moll <pawel.moll@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com> <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet> <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com> <51118797.9080800@linaro.org> <alpine.LFD.2.02.1302182132230.22263@ionos> <5123C3AF.8060100@linaro.org> <1361356160.10155.22.camel@laptop> <51285BF1.2090208@linaro.org> <1361801441.4007.40.camel@laptop> <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com> <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com> <5159D221.70304@linaro.org> <515A0A3A.2040105@gmail.com> <CABPqkBStMd-VT8aoPhFV-rxiLOrH7h2HtS9O9FBkd+ggd5X+xQ@mail.gmail.com> <515C34BF.6060508@gmail.com> <CABPqkBS_z8zzSn=N_Q+AGbo1kV2EMOoF4dz2Aze=rPNB2n_n2g@mail.gmail.com> <515C393C.8030405@gmail.com> <CABPqkBQjur31gpPWTavjSP5nbc7u8mQwqsRRctYiHnPXz0d=_A@mail.gmail.com> <515C6D87.2060106@linaro.org> <CABPqkBRaCgb3Gp8_DT_S5rd9BcpTVeKgY2Ozk_yyAQP4W4SR1Q@mail.gmail.com>
In-Reply-To: <CABPqkBRaCgb3Gp8_DT_S5rd9BcpTVeKgY2Ozk_yyAQP4W4SR1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 01:12 AM, Stephane Eranian wrote:
> On Wed, Apr 3, 2013 at 7:57 PM, John Stultz <john.stultz@linaro.org> wrote:
>> I'm not sure I follow this. If perf exported data came with CLOCK_MONOTONIC
>> timestamps, no correlation would need to be exposed.  perf would just have
>> to do the extra overhead of doing the conversion on export.
> There is no explicit export operation in perf.  You record a sample when
> the counter overflows and generates an NMI interrupt. In the NMI interrupt
> handler, the sample record is written to the sampling buffer. That is when
> the timestamp is generated. The sampling buffer is directly accessible to
> users via mmap(). The perf tool just dumps the raw sampling buffer into
> a file, no sample record is modified or even looked at. The processing
> of the samples is done offline (via perf report) and could be done on
> another machine. In other words, the perf.data file is self-contained.
Ah. Ok, I didn't realize perfs buffers were directly mmaped.  I was 
thinking perf could do the translation not at NMI time but when the 
buffer was later read by the application.  That helps explain some of 
the constraints.

thanks
-john
