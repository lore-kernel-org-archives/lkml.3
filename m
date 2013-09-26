Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3IZLjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:39:04 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:56283 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab3IZLjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:39:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130925073113.GA1027@krava.brq.redhat.com>
References: <1379323053-11458-1-git-send-email-jean.pihet@linaro.org>
	<1379323053-11458-4-git-send-email-jean.pihet@linaro.org>
	<20130917102904.GA27258@mudshark.cambridge.arm.com>
	<CAFrcx1nnx0+kWx3z3A86Fwz13RYRVSPSG0YHBcxFeFQP8W7jBg@mail.gmail.com>
	<20130924093450.GB1008@krava.brq.redhat.com>
	<20130924100620.GG15119@mudshark.cambridge.arm.com>
	<CAFrcx1k-sfHMRz6mvibBbph4vNOMkVddE4LEE4yXbWHC3DwMZA@mail.gmail.com>
	<20130924174318.GE3080@krava.brq.redhat.com>
	<CAFrcx1kw-vEo8m0yNFK1d7Sw+o8C7K7j1feLdOk3Mcdmw9tPcw@mail.gmail.com>
	<20130925073113.GA1027@krava.brq.redhat.com>
Date: Thu, 26 Sep 2013 13:39:00 +0200
Message-ID: <CAFrcx1m8BWd-4jktgsKUdFAoHXWS-eWkOKQroEcNYjDaoQ3pZA@mail.gmail.com>
Subject: Re: [PATCH 3/4] perf tools: Check libunwind for availability of dwarf
 parsing feature
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>, Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri, Will,

I just sent the reworked series as '[PATCH v3 0/4] perf: parse the
dwarf backtrace info from .debug_frame section'.
Tested on x86 and ARMv7.

Regards,
Jean


On 25 September 2013 09:31, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Sep 25, 2013 at 08:53:44AM +0200, Jean Pihet wrote:
>> Hi Jiri,
>>
>> On 24 September 2013 19:43, Jiri Olsa <jolsa@redhat.com> wrote:
>> > On Tue, Sep 24, 2013 at 02:03:47PM +0200, Jean Pihet wrote:
>> >> Hi Jiri, Will,
>> >>
>> >> On 24 September 2013 12:06, Will Deacon <will.deacon@arm.com> wrote:
>> >> > On Tue, Sep 24, 2013 at 10:34:50AM +0100, Jiri Olsa wrote:
>> >> >> On Tue, Sep 24, 2013 at 10:55:32AM +0200, Jean Pihet wrote:
>> >> >> > Ping on the series. The two patches above (3/4 and 4/4) are generic
>> >> >> > while the two others are impacting ARM only.
>> >> >> > Is it possible to get an Ack for the generic ones?
>> >> >>
>> >> >> I'm fine with those changes.. still I'm sort of worried about
>> >> >> current DWARF unwind users (but not sure if there're any),
>> >> >> who depends on packaged libunwind compiled without
>> >> >> --enable-debug-frame option.
>> >> >
>> >> > Since x86 is the only architecture using libunwind with perf at the moment,
>> >> > and I'd expect it to use .eh_frame for unwinding, I'm also not sure there
>> >> > are any existing users to worry about.
>> >> Right
>> >>
>> >> >
>> >> >> I've seen your libunwind patch to make it default, but
>> >> >> not sure if it was accepted.. if not, maybe we should
>> >> >> detect this and build that code conditionaly.
>> >> >
>> >> > It certainly defaults to "on" for ARM, but other architectures have to
>> >> > enable it explicitly afaict.
>> >> Yes that is correct.
>> >> This patch (3/4) detects if the debug frame code is enabled in
>> >> libunwind and uses the lib only if it is the case.
>> >
>> > My concern is about users (again, not sure if there are any ;-) )
>> > that use this with packaged libunwind compiled without
>> > --enable-debug-frame option.
>> >
>> > For them perf will consider libunwind as 'not available' with
>> > your changes:
>> >
>> >       ...
>> >       CHK libunwind
>> >   config/Makefile:223: No libunwind found, disabling post unwind support.  Please install libunwind-dev[el] >= 1.1
>> >       ...
>> >
>> > and they'll need to compile their own libunwind
>> > (thats the case on Fedora).
>> >
>> > This could be solved by detecting this and make your
>> > code conditional as attached below (not much tested).
>> Ok that makes sense.
>> Let me integrate this in the patch series, test it (on ARM and x86)
>> and re-submit. Is that OK?
>
> that'd be great
>
> thanks,
> jirka
