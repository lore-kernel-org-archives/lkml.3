Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaACWG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 17:06:29 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:61518 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbaACWG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:06:26 -0500
Message-ID: <52C7345D.30603@redhat.com>
Date: Fri, 03 Jan 2014 23:06:21 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
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
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com> <4794554.Hmd2RUNYDT@vostro.rjw.lan> <52C18A23.10703@redhat.com> <3710588.K8glfx1cYs@vostro.rjw.lan> <52C6F3B4.3050904@gmail.com> <20140103180435.GK10961@minantech.com> <52C716C1.6070704@gmail.com>
In-Reply-To: <52C716C1.6070704@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/01/2014 21:00, Dirk Brandewie ha scritto:
> +    case MSR_IA32_MPERF:
> +    case MSR_IA32_APERF:

These should never be accessed.  A KVM VM will always have
CPUID[06H].ECX = 0, and the Intel manual says that the MSRs are only
present if CPUID returns that value with bit 0 set.

I think the actual bug is that intel_pstate_init does not check the
feature bits in CPUID (either manually or via x86_match_cpu).

Paolo
