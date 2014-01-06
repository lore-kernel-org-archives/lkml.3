Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaAFLXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:23:35 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53322 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753432AbaAFLXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:23:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@minantech.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Kashyap Chamarthy <kchamart@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
Date: Mon, 06 Jan 2014 12:37:19 +0100
Message-ID: <46313552.v2plfSZzzF@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <52CA9180.1020106@redhat.com>
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com> <4410803.FiVxaMNxvJ@vostro.rjw.lan> <52CA9180.1020106@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 06, 2014 12:20:32 PM Paolo Bonzini wrote:
> Il 04/01/2014 22:38, Rafael J. Wysocki ha scritto:
> > On Saturday, January 04, 2014 07:48:13 PM Gleb Natapov wrote:
> >> On Sat, Jan 04, 2014 at 06:38:59PM +0100, Paolo Bonzini wrote:
> >>> Il 04/01/2014 15:38, Rafael J. Wysocki ha scritto:
> >>>> Well, it's just a sanity check and it makes the problem go away for the reporter.
> >>>>
> >>>>>> Your patch is welcome but perhaps it should have a WARN_ON too.
> >>>> It has been pulled in already, so the WARN_ON() can only be added via a separate
> >>>> patch now.  Would you like to prepare that patch?
> >>>
> >>> Yes, I'll add it together with the CPUID check.  I'll send the patch so
> >>> that it can get into 3.14.
> >>>
> >> CPUID check, while correct, will sweep the problem under the rug. Current
> >> Linux logic should detect non working pstate in KVM. We should look into
> >> why this is not happening for nested.
> > 
> > I agree.  It's better not to use CPUID for that in my opinion.
> 
> Among hypervisors, RHEL5's Xen is probably one of the oldest in actual
> use with new hardware and new kernels, and the CPUID bit has been fixed
> in 2011.  Older versions wouldn't run new kernels due to other CPUID
> bits not being cleared properly in VMs.
> 
> Is there real hardware that has the CPUID bit set and non-working
> pstate?  If there's no such real hardware, CPUID is what the SDM says
> you should use to detect presence of the APERF/MPERF msrs.

OK

> Having extra safety checks is fine on top of what the SDM says, but IMO
> they should be WARN_ONs.  Otherwise you are sweeping bugs under the rug
> just as much.

As I said I'm not against adding WARN_ON()s there. :-)

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
