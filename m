Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab3LVBHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 20:07:13 -0500
Received: from exprod5og119.obsmtp.com ([64.18.0.189]:48591 "HELO
	exprod5og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754867Ab3LVBHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 20:07:11 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Dec 2013 20:07:11 EST
MIME-Version: 1.0
In-Reply-To: <201312212111.40576.arnd@arndb.de>
References: <1387594651-25771-1-git-send-email-rapatel@apm.com>
	<201312212111.40576.arnd@arndb.de>
Date: Sat, 21 Dec 2013 17:00:51 -0800
Message-ID: <CAPw-ZTnsu_EmOW3aZTVKAVjQsdi8qMy95y2ZcYxzgVrjGkirTA@mail.gmail.com>
Subject: Re: [PATCH V2 0/4] misc: xgene: Add support for APM X-Gene SoC Queue
 Manager/Traffic Manager
From: Loc Ho <lho@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ravi Patel <rapatel@apm.com>, gregkh@linuxfoundation.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sat, Dec 21, 2013 at 12:11 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 21 December 2013, Ravi Patel wrote:
>> This patch adds support for APM X-Gene SoC Queue Manager/Traffic Manager.
>>  QMTM is required by APM X-Gene SoC Ethernet, PktDMA (XOR Engine) and
>>  Security Engine subsystems. All subsystems communicate with QMTM using
>>  messages which include information about the work to be performed and
>>  the location of associated data buffers.
>
> Please describe here what the purpose of the qmtm is, as this is not
> entirely clear from the code.
>
> In particular, please describe how this differs from a dmaengine driver
> and why it is not possible to extend the dma slave API to describe qmtm
> as a dma engine.
>
[Loc Ho]
If the QM driver implements the DMA API, what about the actual DMA
engine driver which interfaces with this QM driver. We would have DMA
client interfaces with the X-Gene DMA driver (not available yet) via
DMA API which in turn interfaces with this QM driver via DMA API.
Won't this be kind of awkward? Also, the QM only manage messages (or
descriptors) which are 32-bytes or 64-bytes. It doesn't actually do
any data transfer of various sizes.

-Loc
