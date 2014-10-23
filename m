Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaJWQAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:00:47 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:50545 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaJWQAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:00:45 -0400
Message-ID: <54492629.7030501@cogentembedded.com>
Date: Thu, 23 Oct 2014 20:00:41 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, netdev@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] net: dsa: Report known silicon revisions for Marvell
 88E6060
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net> <1414037002-25528-3-git-send-email-linux@roeck-us.net> <5448F9B4.9010209@cogentembedded.com> <5449008C.4050505@roeck-us.net>
In-Reply-To: <5449008C.4050505@roeck-us.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 05:20 PM, Guenter Roeck wrote:

>>> Report known silicon revisions when probing Marvell 88E6060 switches.

>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> ---
>>>   drivers/net/dsa/mv88e6060.c | 5 ++++-
>>>   1 file changed, 4 insertions(+), 1 deletion(-)

>>> diff --git a/drivers/net/dsa/mv88e6060.c b/drivers/net/dsa/mv88e6060.c
>>> index 05b0ca3..c29aebe 100644
>>> --- a/drivers/net/dsa/mv88e6060.c
>>> +++ b/drivers/net/dsa/mv88e6060.c
>>> @@ -69,8 +69,11 @@ static char *mv88e6060_probe(struct device *host_dev,
>>> int sw_addr)
>>>
>>>       ret = mdiobus_read(bus, sw_addr + REG_PORT(0), 0x03);
>>>       if (ret >= 0) {
>>> -        ret &= 0xfff0;
>>>           if (ret == 0x0600)
>>> +            return "Marvell 88E6060 (A0)";
>>> +        if (ret == 0x0601 || ret == 0x0602)

>>     *else* *if*.

>>> +            return "Marvell 88E6060 (B0)";
>>> +        if ((ret & 0xfff0) == 0x0600)

>>     Likewise?

> The if case returns, so the else would just introduce an unnecessary
> additional level of indentation.

    Not really.

> I think nowadays even checkpatch
> complains about an unnecessary else after return.

    You're right about the *return* though. I should have stayed silent.

> Thanks,
> Guenter

WBR, Sergei

