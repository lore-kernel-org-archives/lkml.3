Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3L2MMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 07:12:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab3L2MMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 07:12:37 -0500
Message-ID: <52C011A2.3040800@redhat.com>
Date: Sun, 29 Dec 2013 13:12:18 +0100
From: Kashyap Chamarthy <kchamart@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Gleb Natapov <gleb@kernel.org>, Josh Boyer <jwboyer@fedoraproject.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com> <20131227170147.GH10961@minantech.com> <52BDB63B.70107@redhat.com> <231382870.yshsPRR4KM@vostro.rjw.lan>
In-Reply-To: <231382870.yshsPRR4KM@vostro.rjw.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[. . .]

>> Here's host dmesg: https://bugzilla.kernel.org/attachment.cgi?id=119751
>>
>>>> Can you ftrace the failure?
>>
>> Can try, need some time (rest of the day I'll be away travelling,
>> will try to do it over the weekend, and update the Kernel
>> bugzilla with observations).
>>
>>>>
>>> Ugh, it looks like guest dmesg but there are KVM messages there too ("[
>>> 281.443662] kvm [2452]: vcpu0 unhandled rdmsr: 0xe8" is unhandled access
>>> to MSR_IA32_APERF I was talking about above), so I guess this is nested
>>> guest invocation? 
>>
>> Yeah -- sorry, I forgot to note it's in a nested environment :(
>>
>>> Does it happen in non nested guest?
>>
>> I need to that.
>>
>> Note to self: Also try with a newer Kernel on the host.
> 
> Please try the patch I posted earlier today when you're at it:
> 
> https://patchwork.kernel.org/patch/3411991/

I applied the patch & tried to build the Kernel, it failed with:

=======
.
.
.
Generating a 4096 bit RSA private key
............................................................................................................drivers/cpufreq/intel_pstate.c:
In function 'intel_pstate_init_cpu':
drivers/cpufreq/intel_pstate.c:617:18: error: 'struct pstate_data' has no member named
'current_state'
  if (!cpu->pstate.current_state) {
                  ^
...make[2]: *** [drivers/cpufreq/intel_pstate.o] Error 1
make[1]: *** [drivers/cpufreq] Error 2
make[1]: *** Waiting for unfinished jobs....
.....................................make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....
...................................++
=======

I'll try it on Fedora Kernel git, do a test build and re-try again.

-- 
/kashyap
