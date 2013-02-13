Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760440Ab3BMRuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:50:55 -0500
Received: from nm25.access.bullet.mail.sp2.yahoo.com ([98.139.44.152]:45878
	"EHLO nm25.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760179Ab3BMRuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:50:54 -0500
X-Yahoo-Newman-Id: 618144.32703.bm@smtp107.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ZJ11omkVM1nWo8TqLAvJcW6_xwq8rl5hgR.W6FP2EAcyLoH
 REjrJW_Sxx9oHY0Of.F1OsBVAGXPX0UnY3ZhZ0A7RPWwUutZw7P8vsyF1d76
 R6DuTC1H1deIG9UROi94YTh5n2S0U3cSIdIMrbpYzlLcEtq1NxISVly4js.p
 kTqNHTKsRRiAlqIGeiBOvw7d8asXN1NjOIK7qqofzz84zuAHXQxAMVulU.vQ
 bTCJ2699prUcZxNEyyqBNK6VZ0EnS5S_5UtdR7H8DenMl9avuFOqwIn_lpBc
 AbxxmtI6d6AspF6B9NrW1G38goPRveUspfHA67cLgpnayGJt4JSNxT1ee.Ne
 XEqX8ytM4jW3QnsPQs7pspvIBS3.YioC_ub6QvUD.hxg8_Hg1KbhILa1p3zq
 nb0tRNc_o84LdV.8CD5uuN2b.gczF1rMZn8nHAcXVP9JHqkGG7rV4kWMbYjd
 AF6qG
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <511BD291.1040003@schaufler-ca.com>
Date: Wed, 13 Feb 2013 09:51:13 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>      <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>      <1360355671.18083.18.camel@x230.lan>      <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>      <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>      <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>      <1360373383.18083.23.camel@x230.lan>      <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>      <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>     <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>    <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan>   <511B33BC.9080307@zytor.com> <1360737709.18083.36.camel@x230.lan>  <511BCB6E.8080102@zytor.com> <1360776399.18083.39.camel@x230.lan>
In-Reply-To: <1360776399.18083.39.camel@x230.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/2013 9:26 AM, Matthew Garrett wrote:
> On Wed, 2013-02-13 at 09:20 -0800, H. Peter Anvin wrote:
>
>> Problem:
>>
>> Someone adds SYS_CAP_RAWIO to some places it definitely does not
>> belong.
>>
>> Solution:
>>
>> Break all the *appropriate* (as defined)uses of SYS_CAP_RAWIO?
> Problem:
>
> CAP_SYS_RAWIO has been used in a bunch of arguably inappropriate places.
> Removing CAP_SYS_RAWIO from the set of possible capabilities on a system
> will prevent userspace from doing things that userspace should be
> permitted to do. Removing CAP_SYS_RAWIO from the places that it
> currently exists will allow userspace to do too much. Replacing
> CAP_SYS_RAWIO with CAP_SYS_ADMIN will prevent userspace from doing
> things that it can currently do.
>
> Solution:
>
> Admit that CAP_SYS_RAWIO is fucked up beyond rescue. Add a new
> capability with well-defined semantics.

You can't add a new capability where there is an existing capability
that can be remotely argued to be appropriate.

If you tried to "fix" CAP_SYS_RAWIO and/or CAP_SYS_ADMIN you'd end
up with hundreds of capabilities.

Your particular problem is *not* so important that you get a
capability all to yourself.


> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���.�+r��n�觶��ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢfl===

