Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab3FCKrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:47:40 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:41450 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753278Ab3FCKri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:47:38 -0400
Message-ID: <51AC73F3.3040300@st.com>
Date: Mon, 03 Jun 2013 11:46:11 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Barry Song <21cnbao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Barry Song <baohua.song@csr.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 2/2] ARM:prima2:move postcore_initcalls to init_machine.
References: <1369993439-24216-1-git-send-email-srinivas.kandagatla@st.com> <1369993517-24735-1-git-send-email-srinivas.kandagatla@st.com> <CAGsJ_4yu2MT5o7hbX67KPhrejS9D1BbPcship4zxtXs3G9tE-Q@mail.gmail.com> <51AC5A53.1090700@st.com> <CAGsJ_4zTJamdH2-3vfqPSrOA+egST3rH_+2mPrhy6=1ZWJxnRg@mail.gmail.com>
In-Reply-To: <CAGsJ_4zTJamdH2-3vfqPSrOA+egST3rH_+2mPrhy6=1ZWJxnRg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/13 11:07, Barry Song wrote:
> i want to move sirfsoc_of_pwrc_init and sirfsoc_of_pwrc_init to
> sirfsoc_pm_init as only suspend entries need them. then the result is
> like:
> 
>  int __init sirfsoc_pm_init(void)
>  {
> +       sirfsoc_of_pwrc_init();
> +       sirfsoc_memc_init();
>         suspend_set_ops(&sirfsoc_pm_ops);
>         return 0;
>  }
> @@ -98,7 +103,7 @@ static const struct of_device_id pwrc_ids[] = {
>         {}
>  };

It looks good, and should fix the issue too.
