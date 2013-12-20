Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab3LTDcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:32:10 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:61341 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3LTDcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:32:08 -0500
MIME-Version: 1.0
In-Reply-To: <20131220032516.GB19320@psi-dev26.jf.intel.com>
References: <1383069507-27574-1-git-send-email-david.a.cohen@linux.intel.com>
	<5282A255.5090904@linux.intel.com>
	<CAA+hA=SuhppL9Ejm1NSRrNmYZ_sE3Xnzf2gLSVYkFf7msEZNHw@mail.gmail.com>
	<20131220032516.GB19320@psi-dev26.jf.intel.com>
Date: Fri, 20 Dec 2013 11:32:07 +0800
Message-ID: <CAA+hA=SApxYn2=orNz8ZEF-uz7TQ8VBrbLcx6Ozzfd+zNuLCFQ@mail.gmail.com>
Subject: Re: [RFC/PATCH 0/2] mmc: sdhci: Workaround Intel Merrifield issue for HS200
From: Dong Aisheng <dongas86@gmail.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Chris Ball <cjb@laptop.org>, Adrian Hunter <adrian.hunter@intel.com>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chuanxiao.dong" <chuanxiao.dong@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 11:25 AM, David Cohen
<david.a.cohen@linux.intel.com> wrote:
> On Fri, Dec 20, 2013 at 11:00:23AM +0800, Dong Aisheng wrote:
>> On Wed, Nov 13, 2013 at 5:49 AM, David Cohen
>> <david.a.cohen@linux.intel.com> wrote:
>> > On 10/29/2013 10:58 AM, David Cohen wrote:
>> >>
>> >> Hi,
>> >>
>> >> SDHCI used to work well on Intel Merrifield until this patch was applied:
>> >>
>> >> commit 156e14b126ffb6f040bc6f1aff3c51077e42a744
>> >> Author: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
>> >> Date:   Wed Jun 12 08:16:38 2013 +0200
>> >>
>> >>      mmc: sdhci: fix caps2 for HS200
>> >>
>> >>      Although the HC supports HS200 (eMMC) the caps2 are always zero; this
>> >>      means there's no way to use the super speed mode (when init the
>> >> card).
>> >>
>> >>      If the HC support SDR104, for SD3.0, so it also supports HS200 for
>> >> eMMC
>> >>      and this patch just sets the MMC_CAP2_HS200 in the host caps2 field.
>> >>
>> >> Looks like there is a hw issue with unknown root cause so far.
>> >>
>> >> Is it acceptable to have the quirk I'm proposing to workaround the issue?
>> >
>> >
>> > Ping. Any comments here?
>> >
>>
>> Chris,
>> Can you pick this one?
>> IMX also needs this quirk for imx6q/dl since it can not meet HS200
>> timing requirement.
>>
>>
>> David,
>> Is the unkonwn hw issue in your patch #2 resolved now?
>> If yes, you may not need this quirk.
>> I could resend it with your sign-off with IMX patches.
>
> Merrifield still needs this quirk to not break MMC support.
> This quirk could be applied to 3.13-rc (since merrifield was added to
> sdhci-pci.c on 3.13-rc1).
>

Okay, thanks for the information.
So please take my ACK:
Acked-by: Dong Aisheng <b29396@freescale.com>

I will send IMX patches based on it.

Regards
Dong Aisheng

> Br, David
>
>>
>> Regards
>> Dong Aisheng
>>
>> > Br, David Cohen
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> >
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
