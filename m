Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaEDKWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 06:22:46 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:33379
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752593AbaEDKWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 06:22:44 -0400
Message-ID: <536614E7.9050301@freescale.com>
Date: Sun, 4 May 2014 18:22:31 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <scottwood@freescale.com>,
        <leo.li@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 8/8] DMA: Freescale: add suspend resume functions for
 DMA driver
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
 <1397809071-5353-9-git-send-email-hongbo.zhang@freescale.com>
 <20140502164604.GB32284@intel.com>
In-Reply-To: <20140502164604.GB32284@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(979002)(6009001)(479174003)(377454003)(51704005)(199002)(189002)(24454002)(4396001)(76176999)(54356999)(65806001)(47776003)(20776003)(64706001)(50466002)(99136001)(92566001)(92726001)(64126003)(33656001)(77982001)(99396002)(46102001)(77096999)(65956001)(80022001)(65816999)(21056001)(50986999)(59896001)(87266999)(83072002)(83506001)(86362001)(23756003)(76482001)(19580405001)(83322001)(80316001)(19580395003)(44976005)(6806004)(79102001)(80976001)(36756003)(81342001)(31966008)(74502001)(87936001)(81542001)(85852003)(74662001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB399;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 02015246A9
Authentication-Results: spf=fail (sender IP is 192.88.168.1)
 smtp.mailfrom=hongbo.zhang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/03/2014 12:46 AM, Vinod Koul wrote:
> On Fri, Apr 18, 2014 at 04:17:51PM +0800, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> This patch adds suspend resume functions for Freescale DMA driver.
>> .prepare callback is used to stop further descriptors from being added into the
>> pending queue, and also issue pending queues into execution if there is any.
>> .suspend callback makes sure all the pending jobs are cleaned up and all the
>> channels are idle, and save the mode registers.
>> .resume callback re-initializes the channels by restore the mode registers.
>>
>> +
>> +static const struct dev_pm_ops fsldma_pm_ops = {
>> +	.prepare	= fsldma_prepare,
>> +	.suspend	= fsldma_suspend,
>> +	.resume		= fsldma_resume,
>> +};
> I think this is not correct. We discussed this sometime back on list. The
> DMAengine drivers should use late resume and early suspend to ensure they get
> suspended after clients (who should use normal ones) and resume before them
>
OK, will update it like this:
use .suspend to take place of current .prepare
use .suspend_late to take place of current .suspend
use .resume_early to take place of current .resume



