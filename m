Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab3FCKHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:07:50 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:60725 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab3FCKHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:07:48 -0400
MIME-Version: 1.0
In-Reply-To: <51AC5A53.1090700@st.com>
References: <1369993439-24216-1-git-send-email-srinivas.kandagatla@st.com>
 <1369993517-24735-1-git-send-email-srinivas.kandagatla@st.com>
 <CAGsJ_4yu2MT5o7hbX67KPhrejS9D1BbPcship4zxtXs3G9tE-Q@mail.gmail.com> <51AC5A53.1090700@st.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 3 Jun 2013 18:07:27 +0800
Message-ID: <CAGsJ_4zTJamdH2-3vfqPSrOA+egST3rH_+2mPrhy6=1ZWJxnRg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] ARM:prima2:move postcore_initcalls to init_machine.
To: srinivas.kandagatla@st.com
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Barry Song <baohua.song@csr.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srinivas,

2013/6/3 Srinivas KANDAGATLA <srinivas.kandagatla@st.com>:
> On 03/06/13 04:51, Barry Song wrote:
>> did you see this one?
>>
>> [PATCH v2] arm: prima2: use of_platform_populate instead of
>> of_platform_bus_probe
>> http://www.spinics.net/lists/arm-kernel/msg243710.html
>
> Yes, I think this is a nice cleanup for simplest case. But Prima
> platforms do much more checking at the same init level. An attempt to
> get rid of postcore and early init calls might introduce this back.
>
> You could solve both the early and postcore initcall issues by returning
> instead of panic, and let every NON Prima platforms call this function.
> Or
> Do it the right way and clean it up.
>
> I will leave it up to you to decide on how you want to fix the multi_v7
> kernel issue.

i want to move sirfsoc_of_pwrc_init and sirfsoc_of_pwrc_init to
sirfsoc_pm_init as only suspend entries need them. then the result is
like:

 int __init sirfsoc_pm_init(void)
 {
+       sirfsoc_of_pwrc_init();
+       sirfsoc_memc_init();
        suspend_set_ops(&sirfsoc_pm_ops);
        return 0;
 }
@@ -98,7 +103,7 @@ static const struct of_device_id pwrc_ids[] = {
        {}
 };


>
> Thanks,
> srini

-barry
