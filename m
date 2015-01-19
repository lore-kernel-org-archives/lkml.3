Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbbASFNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 00:13:15 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:47950 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbbASFNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 00:13:14 -0500
From: Alok Kataria <akataria@vmware.com>
To: "jgross@suse.com" <jgross@suse.com>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jongman.heo@samsung.com" <jongman.heo@samsung.com>
Subject: Re: [Patch RESEND] x86: don't rely on VMWare emulating PAT MSR
 correctly
Thread-Topic: [Patch RESEND] x86: don't rely on VMWare emulating PAT MSR
 correctly
Thread-Index: AQHQLiba4W8zAVyO8kO70dnXpc7EzpzHdN+AgAACi4A=
Date: Mon, 19 Jan 2015 05:13:00 +0000
Message-ID: <1421644471.941.25.camel@akataria-dtop.eng.vmware.com>
References: <1421039745-14335-1-git-send-email-jgross@suse.com>
	 <54BC9095.9080506@suse.com>
In-Reply-To: <54BC9095.9080506@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.113.160.246]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B94259E5344AA42B58F15A46253310D@pa-exch1.vmware.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J5DLMk000897

Juergen, thanks for following up on this. 

X86 maintainers - If it helps let me also confirm that without this
patch the latest kernels *always* crash on VMware guest running HWv10
and earlier.

Please include the fix at your earliest. 

Thanks,
Alok

On Mon, 2015-01-19 at 06:05 +0100, Juergen Gross wrote:
> PING!
> 
> The patch repairs a bug with VMWARE, which has been reported by several
> users. All of them have confirmed the patch is working. And VMWARE has
> acked the patch. What else do you need to take it? It is available for
> over a month now!
> 
> Juergen
> 
> On 01/12/2015 06:15 AM, Juergen Gross wrote:
> > VMWare seems not to emulate the PAT MSR correctly: reaeding
> > MSR_IA32_CR_PAT returns 0 even after writing another value to it.
> >
> > Detect this bug and don't use the read value if it is 0.
> >
> > Commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2 ("x86: Enable PAT to
> > use cache mode translation tables") triggers this VMWare bug when the
> > kernel is booted as a VMWare guest.
> >
> > Reported-by: Jongman Heo <jongman.heo@samsung.com>
> > Signed-off-by: Juergen Gross <jgross@suse.com>
> > Tested-by: Jongman Heo <jongman.heo@samsung.com>
> > Acked-by: Alok N Kataria <akataria@vmware.com>
> > ---
> >   arch/x86/mm/pat.c | 7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> > index edf299c..7ac6869 100644
> > --- a/arch/x86/mm/pat.c
> > +++ b/arch/x86/mm/pat.c
> > @@ -234,8 +234,13 @@ void pat_init(void)
> >   	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
> >
> >   	/* Boot CPU check */
> > -	if (!boot_pat_state)
> > +	if (!boot_pat_state) {
> >   		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
> > +		if (!boot_pat_state) {
> > +			pat_disable("PAT read returns always zero, disabled.");
> > +			return;
> > +		}
> > +	}
> >
> >   	wrmsrl(MSR_IA32_CR_PAT, pat);
> >
> >
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
