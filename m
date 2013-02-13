Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761164Ab3BMW6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:58:12 -0500
Received: from nm6-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.158]:40929
	"EHLO nm6-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760432Ab3BMW6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:58:10 -0500
X-Yahoo-Newman-Id: 134876.46929.bm@smtp106.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: lvyp8pwVM1nEPSMIwHqYgmOaVRm.qOQRg7DAUJqQ6v5_C6.
 HfRAQ0wC7QpK4QxJppA9lVLeptZgYD6FxR1ny14lhnqtG_ZxW.krE0C94Ez7
 j9QzUQkGBh8BmwSIkJqwOan8sp3uDiNvJj43XKCaq2Y6awbSIAqGNE2AHv0y
 mQzKD8u_i7ZX1Pz5.jJa9.EmJDF44_rd9N0d1sF4r7y7cIfbNP2DQbM7D5GJ
 3.Jfl599l5AClMwFGslyiHR5iGxyHvgjIOg66gC02tWrwR3ufo_La258qxQ0
 GoLsmu.gT2sqxFewG_rqh2szV9U_JessBSaKOyHl0lKf4SHRThdKjUSwsiMc
 z8mt3UOnxRpK14y1lfjZH5b6uRKDKsFnrL8CuzPCXIKHLBwrQkaFoFVjWw62
 MznY4qR8FDY7iBLvCbeIGiN_2JkC19Hi0BJwKtAQz.lIJpMIxyEpGrKoZOZI
 nyvfI
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <511C1A94.8020804@schaufler-ca.com>
Date: Wed, 13 Feb 2013 14:58:28 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>      <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>      <1360355671.18083.18.camel@x230.lan>      <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>      <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>      <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>      <1360373383.18083.23.camel@x230.lan>      <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>      <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>     <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>    <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan>   <511B33BC.9080307@zytor.com> <1360737709.18083.36.camel@x230.lan>  <511BCB6E.8080102@zytor.com> <1360776399.18083.39.camel@x230.lan> <511BD291.1040003@schaufler-ca.com> <511C1325.5060601@zytor.com>
In-Reply-To: <511C1325.5060601@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/2013 2:26 PM, H. Peter Anvin wrote:
> On 02/13/2013 09:51 AM, Casey Schaufler wrote:
>>
>> You can't add a new capability where there is an existing capability
>> that can be remotely argued to be appropriate.
>>
>> If you tried to "fix" CAP_SYS_RAWIO and/or CAP_SYS_ADMIN you'd end
>> up with hundreds of capabilities.
>>
>> Your particular problem is *not* so important that you get a
>> capability all to yourself.
>>
>
> {facepalm}
>
> This is exactly the kind of thinking which has led to the capability
> system being so bloody useless.

The reason the capability system is "bloody useless" is
that no one wants to update the core system applications to
use it in favor of good old fashioned worked for dad and
works for me too superuser.

>
> Capabilities need to be associated with resources, not use cases.

There is no such thing as a "resource" in the Linux security
policy model. The Linux security policy model is based on
subjects (tasks) accessing objects (e.g. files). Capabilities
provide a granular mechanism for granting privilege to
violate the Linux security policy.

Because in the Bad Old days of Unix "superuser privilege"
also granted rights to preform configuration activities it
was not possible to eliminate the superuser without extending
the capability mechanism to include these. Thus, there are two
sorts of capabilities, those controlling privileged access and
those controlling restricted activities.

In both cases what you are controlling is an activity. Sorry,
but that is the way it is defined.

I understand that you want capabilities to be associated with
resources. That is *not* what we have, and arguing that its
what we should have is pointless because Linux does not even
have a concept of resources.

>
>     -hpa
>
>

