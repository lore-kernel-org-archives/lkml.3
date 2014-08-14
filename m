Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaHNV5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:57:55 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:39438
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754400AbaHNV5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:57:53 -0400
X-WSS-ID: 0NABGZP-08-7D6-02
X-M-MSG: 
Message-ID: <53ED30BD.90403@amd.com>
Date: Thu, 14 Aug 2014 16:57:17 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>, Clemens Ladisch <clemens@ladisch.de>
CC: Guenter Roeck <linux@roeck-us.net>, <jdelvare@suse.de>,
        <rdunlap@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <dan.carpenter@oracle.com>,
        <lm-sensors@lm-sensors.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] hwmon, k10temp: Add support for F15h M60h
References: <1408035262-18026-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20140814201730.GA501@roeck-us.net> <53ED1A87.6000400@ladisch.de>
 <20140814210816.GC18887@pd.tnic>
In-Reply-To: <20140814210816.GC18887@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019004)(6009001)(428002)(164054003)(377454003)(479174003)(189002)(24454002)(199003)(64706001)(83322001)(21056001)(97736001)(85852003)(65816999)(102836001)(95666004)(81542001)(44976005)(54356999)(107046002)(47776003)(36756003)(20776003)(33656002)(50986999)(83072002)(99396002)(85306004)(101416001)(105586002)(79102001)(23676002)(83506001)(65806001)(106466001)(87936001)(65956001)(76176999)(74502001)(92566001)(77982001)(93886004)(92726001)(74662001)(4396001)(46102001)(86362001)(81342001)(68736004)(84676001)(76482001)(31966008)(50466002)(80022001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB043;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03030B9493
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/2014 4:08 PM, Borislav Petkov wrote:
> On Thu, Aug 14, 2014 at 10:22:31PM +0200, Clemens Ladisch wrote:
>>>> +	depends on X86 && PCI && AMD_NB
>>> Is the added dependency acceptable ?
>> Yes, it is automatically set from CPU_SUP_AMD.
> Well, we can always move that function to k10temp but I'll venture a
> guess that Aravind wants to use it somewhere else too? Correct, Aravind?
>

Actually I don't need it outside of k10temp as of now (or near future)
I added it in amd_nb as that was Clemens, Guenter's suggestion on the 
previous version;
Besides, it made sense as it's an indirect access of NB_SMU register and 
amd_nb seems a good place to put the function in case someone needs it 
in the future.

I can move it locally to k10temp and remove the dependency if that's 
more preferable. Do let me know.

Thanks,
-Aravind.
