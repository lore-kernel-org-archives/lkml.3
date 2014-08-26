Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaHZFjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:39:11 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:40976 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750731AbaHZFjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:39:09 -0400
Message-ID: <53FC1D68.1000600@st.com>
Date: Tue, 26 Aug 2014 07:38:48 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vince Bridgers <vbridgers2013@gmail.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Ley Foon Tan <lftan@altera.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <lftan.linux@gmail.com>,
        Vince Bridgers <vbridger@altera.com>
Subject: Re: [PATCH] net: stmmac: add dcrs parameter
References: <1408967442-2724-1-git-send-email-lftan@altera.com>	<CAGb2v65fi=D_TQBSospft4T5OrBCj5TwQfgtkX=11M8TWFftYg@mail.gmail.com>	<53FB313C.9010808@st.com> <CAOwfj2Oyy8EGxPhgJcgeGPMm3tJ9-fGOh5h7jU8q4_BO=vWrTA@mail.gmail.com>
In-Reply-To: <CAOwfj2Oyy8EGxPhgJcgeGPMm3tJ9-fGOh5h7jU8q4_BO=vWrTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.46]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-26_03:2014-08-25,2014-08-26,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/25/2014 5:10 PM, Vince Bridgers wrote:
> Hi,
>
> On Mon, Aug 25, 2014 at 7:51 AM, Giuseppe CAVALLARO
> <peppe.cavallaro@st.com> wrote:
>> On 8/25/2014 2:34 PM, Chen-Yu Tsai wrote:
>>>
>>> Hi,
>>>
>>> On Mon, Aug 25, 2014 at 7:50 PM, Ley Foon Tan <lftan@altera.com> wrote:
>>>>
>>>> This patch add the option to enable DCRS bit in GMAC control register.
>>>> Default is disabled if snps,dcrs is not defined.
>>>>
>>>> For MII, Carrier Sense (CRS) must be asserted during transmission
>>>> whereas in RGMII, CRS is not. RGMII does not provide a way to signal
>>>> loss of carrier during a transmission.
>
> While technically true, from a practical point of view, this is only
> useful if using true half-duplex media (like the now obsolete 10Base2
> and 10Base5 - think old school coax with vampire taps).
>
>>>>
>>>> When DCRS bit set high in control register, the MAC transmitter
>>>> ignore the (G)MII Carrier Sense signal during frame transmission
>>>> in the half-duplex mode. This request results in no errors generated
>>>> because of Loss of Carrier or No Carrier during such transmission.
>>>>
>>>> Signed-off-by: Ley Foon Tan <lftan@altera.com>
>>>> ---
>
> <snip>
>
>>>
>>> Since you know this is only required under (G)MII, could you not re-use
>>> the "phy-mode" property, instead of adding another one?
>>>
>>> Better yet, use the "interface" field in the platform data. This way
>>> you'll
>>> fix non-DT devices as well. You could then avoid touching the platform
>>> driver,
>>> and just modify the driver core.
>>
>>
>> yes this is what I asked. Thx ChenYu for the this detail.
>> Ley Foon Tan, could you do that? Let me know
>>
>> peppe
>>
>>
>
> In the Synopsys EMAC case, carrier sense is used to stop transmitting
> if no carrier is sensed during a transmission. This is only useful if
> the media in use is true half duplex media (like obsolete 10Base2 or
> 10Base5). If no one in using true half duplex media, then is it
> possible to set this disable by default? If we're not sure, then
> having an option feels like the right thing to do.

Indeed this is what I had done in the patch.

http://git.stlinux.com/?p=stm/linux-sh4-2.6.32.y.git;a=commit;h=b0b863bf65c36dc593f6b7b4b418394fd880dae2

Also in case of carrier sense the frame will be dropped in any case
later.

Let me know if you Acked this patch so I will rebase it on
net.git and I send it soon

peppe

>
> Vince
>

