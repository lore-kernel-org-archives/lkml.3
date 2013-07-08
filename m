Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3GHXSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 19:18:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64063 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab3GHXSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 19:18:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: Re: [PATCH v1 0/4] ARM: STi fixes and ethernet support
Date: Tue, 9 Jul 2013 01:18:06 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Olof Johansson <olof@lixom.net>
References: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201307090118.06715.arnd@arndb.de>
X-Provags-ID: V02:K0:VE0G2JZKVsRQbCtWjbBnaH26F1BYVcMRY5/MhmWQPJc
 xx50RpCv99TpddBKROLVbUaJhLVh1fzHT1fihhc2sTNZuNI3bq
 DE4KSUIT3XBbzsNIfmM8Rar5xAPSwinPc6UCHWFJdTRFmv6ajk
 PuIyxGCj2jAOQzIh/UYbg35E0LaJcjzv2P83yXFz/f5xCWVGBQ
 dMmLkTo9XUNW3TcKte+5RGjnIXRA8N29QZe7csRehLu6736JXM
 sKox1Oqqq0sBYvGA53JZBoZwq9sWINofwRqVQXwuPj82XPU0R/
 ekydhUlkeQ/mXnvK+q8wpEE/zXBVFW1a83CbRVRYteQD24LfR0
 w38RITF5CJuvOAjJ5Y+c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 July 2013, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch series fixes 2 configuration issues and adds ethernet support to
> STiH415, STiH416 based B2000, B2020 boards.
> With this patchset B2000 and B2020 can have basic ethernet support in
> MII and RGMII modes.
> 
> Thanks,
> srini
> 
> Srinivas Kandagatla (4):
>   ARM: dts: STi: Fix pinconf setup for STiH416 serial2
>   ARM: STi: Set correct ARM ERRATAs.
>   ARM: STi: Add STiH415 ethernet support.
>   ARM: STi: Add STiH416 ethernet support.

Hi Srini,

You really have to send those things separately, as the bug fixes should
probably go into 3.11, while the rest is new features and needs to be
reviewed for merging into 3.12.

I'm also puzzled by the fact that you add auxdata and callback
functions for the ether part in the platform code. Those should
probably all be properties added to the stmmac binding.

	Arnd
