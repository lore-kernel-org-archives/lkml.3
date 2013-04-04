Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764721Ab3DDTnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:43:46 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:58870 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764631Ab3DDTno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:43:44 -0400
Message-ID: <515DD7EE.2080903@lwfinger.net>
Date: Thu, 04 Apr 2013 14:43:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (wireless-next
 tree related)
References: <20130404181043.c191e7f4aa3057e6eda151cc@canb.auug.org.au>
In-Reply-To: <20130404181043.c191e7f4aa3057e6eda151cc@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 02:10 AM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> drivers/net/wireless/rtlwifi/rtl8188ee/built-in.o: In function `.rtl92c_phy_ap_calibrate':
> (.text+0x21d14): multiple definition of `.rtl92c_phy_ap_calibrate'
> drivers/net/wireless/rtlwifi/rtl8192c/built-in.o:(.text+0xb1e8): first defined here
> drivers/net/wireless/rtlwifi/rtl8188ee/built-in.o: In function `rtl_hal_pwrseqcmdparsing':
> (.opd+0xed0): multiple definition of `rtl_hal_pwrseqcmdparsing'
> drivers/net/wireless/rtlwifi/rtl8723ae/built-in.o:(.opd+0x11a0): first defined here
> drivers/net/wireless/rtlwifi/rtl8188ee/built-in.o: In function `rtl92c_phy_ap_calibrate':
> (.opd+0xe58): multiple definition of `rtl92c_phy_ap_calibrate'
> drivers/net/wireless/rtlwifi/rtl8192c/built-in.o:(.opd+0x570): first defined here
> drivers/net/wireless/rtlwifi/rtl8188ee/built-in.o: In function `.rtl_hal_pwrseqcmdparsing':
> (.text+0x22164): multiple definition of `.rtl_hal_pwrseqcmdparsing'
> drivers/net/wireless/rtlwifi/rtl8723ae/built-in.o:(.text+0x297a8): first defined here
>
> Caused by commit f0eb856e0b6c ("rtlwifi: rtl8188ee: Add new driver").
>
> I reverted commit 8b138d4898a0 ("rtlwifi: rtl8188ee: Enable build of new
> driver") for today.

I don't know why it is so hard to remember to do an allyesconfig build, but I 
seem to forget. The 2.5 hours it takes on my box does not help.

As you have probably seen, I just submitted a patch to fix the problem.

Thanks for the report,

Larry



