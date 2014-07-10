Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaGJMSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:18:47 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:58366 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaGJMSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:18:45 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Joe Perches <joe@perches.com>,
        sanjeev sharma <sanjeevsharmaengg@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rmfrfs@gmail.com" <rmfrfs@gmail.com>,
        "peter.senna@gmail.com" <peter.senna@gmail.com>,
        "teobaluta@gmail.com" <teobaluta@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 4/4] staging: rtl8192u: Fixed too long lines
Thread-Topic: [PATCH v3 4/4] staging: rtl8192u: Fixed too long lines
Thread-Index: AQHPm259j0XgeRZkpEebJsdbY1YH4ZuXouEAgAGYAeA=
Date: Thu, 10 Jul 2014 12:18:42 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE938EFFA81@EU-MBX-04.mgc.mentorg.com>
References: <20140708100142.GR25934@mwanda>
	 <1404908382-7043-1-git-send-email-sanjeevsharmaengg@gmail.com>
	 <1404908382-7043-5-git-send-email-sanjeevsharmaengg@gmail.com>
 <1404910612.932.95.camel@joe-AO725>
In-Reply-To: <1404910612.932.95.camel@joe-AO725>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 10 Jul 2014 12:18:43.0540 (UTC) FILETIME=[1752B940:01CF9C39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

I have incorporated your review comment  in version v4.

Regards
Sanjeev Sharma 

-----Original Message-----
From: Joe Perches [mailto:joe@perches.com] 
Sent: Wednesday, July 09, 2014 6:27 PM
To: sanjeev sharma
Cc: gregkh@linuxfoundation.org; rmfrfs@gmail.com; peter.senna@gmail.com; teobaluta@gmail.com; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; Sharma, Sanjeev
Subject: Re: [PATCH v3 4/4] staging: rtl8192u: Fixed too long lines

On Wed, 2014-07-09 at 17:49 +0530, sanjeev sharma wrote:
> This patch will fix too long lines warning reported by checkpatch.pl.

Hi Sanjeev.

> diff --git a/drivers/staging/rtl8192u/r819xU_phy.c 
> b/drivers/staging/rtl8192u/r819xU_phy.c
[]
> @@ -1786,7 +1788,9 @@ void InitialGainOperateWorkItemCallBack(struct work_struct *work)
>  		RT_TRACE(COMP_SCAN, "Scan BBInitialGainRestore 0xa0a is %x\n",
>  			 priv->initgain_backup.cca);
>  
> -		rtl8192_phy_setTxPower(dev, priv->ieee80211->current_network.channel);
> +		rtl8192_phy_setTxPower(dev,
> +					priv->ieee80211->current_network.channel
> +				       );

This one is a little off

+		rtl8192_phy_setTxPower(dev,
+					priv->ieee80211->current_network.channel
+				       );

Please align multiline statements to the appropriate open parenthesis using a mix of initial leading tabs followed by the minimal number of spaces required to put the first non-whitespace char at the column immediately after the preceding open paren.

Here it's 4 tabs, 7 spaces, not 5 tabs:

+		rtl8192_phy_setTxPower(dev,
+				       priv->ieee80211->current_network.channel);

And please don't use a line that's just a close parenthesis and semicolon.

I think it's better to ignore the 80 column limit for these and place them at the end of the preceding line.


