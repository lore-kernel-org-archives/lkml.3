Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3L0Vi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 16:38:28 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52956 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754778Ab3L0Vi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 16:38:27 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kashyap Chamarthy <kchamart@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, Josh Boyer <jwboyer@fedoraproject.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
Date: Fri, 27 Dec 2013 22:51:59 +0100
Message-ID: <231382870.yshsPRR4KM@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52BDB63B.70107@redhat.com>
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com> <20131227170147.GH10961@minantech.com> <52BDB63B.70107@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 27, 2013 06:17:47 PM Kashyap Chamarthy wrote:
> On 12/27/2013 06:01 PM, Gleb Natapov wrote:
> > On Fri, Dec 27, 2013 at 06:52:48PM +0200, Gleb Natapov wrote:
> >> On Fri, Dec 27, 2013 at 03:15:39PM +0100, Kashyap Chamarthy wrote:
> >>> [. . .]
> >>>
> >>>>> KVM does not emulate P-states at all. intel_pstate_init() calls
> >>>>> intel_pstate_msrs_not_valid() before printing "Intel P-state driver
> >>>>> initializing."  which suppose to fail since it checks that two reads of
> >>>>> MSR_IA32_APERF return different values, but KVM does not emulate this msr
> >>>>> at all, so both calls should return zero (KVM suppose to inject #GP, all rdmsrl
> >>>>> are patched to be rdmsrl_safe in a guest).
> >>>>>
> >>>>> Anything interesting in host dmesg?
> >>>
> >>> Heya Gleb,
> >>>
> >>> Here's the relevant dmesg snippet (full dmesg, refer the attachment below):
> >> That's guest dmesg. What about host one? 
> 
> Here's host dmesg: https://bugzilla.kernel.org/attachment.cgi?id=119751
> 
> >> Can you ftrace the failure?
> 
> Can try, need some time (rest of the day I'll be away travelling,
> will try to do it over the weekend, and update the Kernel
> bugzilla with observations).
> 
> >>
> > Ugh, it looks like guest dmesg but there are KVM messages there too ("[
> > 281.443662] kvm [2452]: vcpu0 unhandled rdmsr: 0xe8" is unhandled access
> > to MSR_IA32_APERF I was talking about above), so I guess this is nested
> > guest invocation? 
> 
> Yeah -- sorry, I forgot to note it's in a nested environment :(
> 
> > Does it happen in non nested guest?
> 
> I need to that.
> 
> Note to self: Also try with a newer Kernel on the host.

Please try the patch I posted earlier today when you're at it:

https://patchwork.kernel.org/patch/3411991/

Rafael

