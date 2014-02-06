Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaBFOVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:21:17 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:54326 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbaBFOVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:21:14 -0500
Message-ID: <52F39A56.4050309@epfl.ch>
Date: Thu, 06 Feb 2014 15:21:10 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: Andreas Larsson <andreas@gaisler.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] can: sja1000: of: add reg-io-width property for
 8, 16 and 32-bit register access
References: <1391175277-19833-1-git-send-email-florian.vaussard@epfl.ch> <1391175277-19833-6-git-send-email-florian.vaussard@epfl.ch> <52EBAE41.8060403@cogentembedded.com> <52F36AAA.9000704@pengutronix.de>
In-Reply-To: <52F36AAA.9000704@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/06/2014 11:57 AM, Marc Kleine-Budde wrote:
> On 01/31/2014 03:08 PM, Sergei Shtylyov wrote:
>> Hello.
>>
>> On 31-01-2014 17:34, Florian Vaussard wrote:
>>
>>> Add the 'reg-io-width' property for 8, 16 and 32-bit access, like
>>> what is currently done with IORESOURCE_MEM_{8,16,32}BIT for non-OF
>>> boot.
>>
>>> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
>>> ---
>>>   drivers/net/can/sja1000/sja1000_platform.c | 16 ++++++++++++++--
>>>   1 file changed, 14 insertions(+), 2 deletions(-)
>>
>>> diff --git a/drivers/net/can/sja1000/sja1000_platform.c
>>> b/drivers/net/can/sja1000/sja1000_platform.c
>>> index 50dece8..25122bf 100644
>>> --- a/drivers/net/can/sja1000/sja1000_platform.c
>>> +++ b/drivers/net/can/sja1000/sja1000_platform.c
>>> @@ -102,8 +102,20 @@ static void sp_populate_of(struct sja1000_priv
>>> *priv, struct device_node *of)
>>>       int err;
>>>       u32 prop;
>>>
>>> -    priv->read_reg = sp_read_reg8;
>>> -    priv->write_reg = sp_write_reg8;
>>> +    err = of_property_read_u32(of, "reg-io-width", &prop);
>>> +    if (err)
>>> +        prop = 1;
>>> +
>>> +    if (prop == 4) {
>>
>>    This is asking to be a *switch* statement instead.
> 
> Good point, I'll send a v4.
> 

Thank you!

Florian
