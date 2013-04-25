Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab3DYRS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:18:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58411 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757807Ab3DYRS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:18:27 -0400
Message-ID: <5179652F.8080507@zytor.com>
Date: Thu, 25 Apr 2013 10:17:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Jacob Shin <jacob.shin@amd.com>, Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com> <1366703825-19373-2-git-send-email-jacob.shin@amd.com> <20130423095437.GD17593@mudshark.cambridge.arm.com> <20130423143423.GB17021@jshin-Toonie> <20130423144057.GA19644@jshin-Toonie> <20130423150240.GD18616@mudshark.cambridge.arm.com> <20130423151846.GA22052@jshin-Toonie> <20130424094853.GB21850@mudshark.cambridge.arm.com> <20130424163038.GA29816@jshin-Toonie> <20130425170635.GA1324@redhat.com>
In-Reply-To: <20130425170635.GA1324@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 10:06 AM, Oleg Nesterov wrote:
>>
>> The downside is that in userland perf tool we need differing documentation
>> on what the mask syntax means for each architecture.
> 
> Personally I think this is acceptable.
> 
> But I am new to this code, so...
> 

That would seem really, really awkward.  Yes, perf has a bunch of
low-level stuff, but it would seem highly undesirable to force the user
to deal with something like that.

It would be good to have a user-friendly syntax that covers most of what
users may want to do and perhaps a longer form that can express
everything including ARM's byte selects; if the system can't honor the
request it should return an error.

	-hpa


