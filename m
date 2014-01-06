Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbaAFRSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:18:43 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61968 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaAFRSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:18:41 -0500
Message-ID: <52CAE574.3010304@gmail.com>
Date: Mon, 06 Jan 2014 09:18:44 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kashyap Chamarthy <kchamart@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com> <4794554.Hmd2RUNYDT@vostro.rjw.lan> <52C18A23.10703@redhat.com> <3710588.K8glfx1cYs@vostro.rjw.lan> <52C6F3B4.3050904@gmail.com> <20140103180435.GK10961@minantech.com> <52C716C1.6070704@gmail.com> <52C7345D.30603@redhat.com>
In-Reply-To: <52C7345D.30603@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 02:06 PM, Paolo Bonzini wrote:
> Il 03/01/2014 21:00, Dirk Brandewie ha scritto:
>> +    case MSR_IA32_MPERF:
>> +    case MSR_IA32_APERF:
>
OK I will spin the patch to only add MSR_PLATFORM_INFO.

> These should never be accessed.  A KVM VM will always have
> CPUID[06H].ECX = 0, and the Intel manual says that the MSRs are only
> present if CPUID returns that value with bit 0 set.
>
> I think the actual bug is that intel_pstate_init does not check the
> feature bits in CPUID (either manually or via x86_match_cpu).

I will add the feature check.

What are the differences between the first and the nested KVM's?
At load time intel_pstate checks that APERF and MPERF are incrementing
and that PLATFORM_INFO has some value.  Somehow these checks pass
in the nested environment and we fall over when the CPU is being added
by cpufreq.

--Dirk

