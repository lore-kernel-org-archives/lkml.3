Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaJ1Nbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:31:46 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:43936 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaJ1Nbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:31:45 -0400
Message-ID: <544F9ABC.4010306@roeck-us.net>
Date: Tue, 28 Oct 2014 06:31:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/15] net: dsa: Add support for switch EEPROM access
References: <1414342365-27191-1-git-send-email-linux@roeck-us.net> <1414342365-27191-10-git-send-email-linux@roeck-us.net>
In-Reply-To: <1414342365-27191-10-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.544F9AC0.0003,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2014 09:52 AM, Guenter Roeck wrote:
> On some chips it is possible to access the switch eeprom.
> Add infrastructure support for it.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---

[ ... ]

> @@ -603,6 +604,9 @@ static int dsa_of_probe(struct platform_device *pdev)
>   	if (pd->nr_chips > DSA_MAX_SWITCHES)
>   		pd->nr_chips = DSA_MAX_SWITCHES;
>
> +	if (!of_property_read_u32(np, "eeprom-length", &eeprom_length))
> +		pd->eeprom_length = eeprom_length;

This is buggy; please don't apply. Variable is named eeprom_len, and it is
per switch.

Lesson to self: When writing devicetree code, compile it with devicetree enabled.

Guenter

