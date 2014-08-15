Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaHOOts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:49:48 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:48417
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751076AbaHOOtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:49:47 -0400
X-WSS-ID: 0NACRUQ-08-RA2-02
X-M-MSG: 
Message-ID: <53EE1E04.9080406@amd.com>
Date: Fri, 15 Aug 2014 09:49:40 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, <clemens@ladisch.de>,
        <jdelvare@suse.de>, <rdunlap@infradead.org>, <bp@suse.de>
CC: <lm-sensors@lm-sensors.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] hwmon, k10temp: Add support for F15h M60h
References: <1408058127-19374-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <53EDE4B3.6090903@roeck-us.net>
In-Reply-To: <53EDE4B3.6090903@roeck-us.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019004)(6009001)(428002)(479174003)(24454002)(51704005)(189002)(377454003)(199003)(41574002)(52314003)(80316001)(19580405001)(33656002)(95666004)(36756003)(76482001)(19580395003)(20776003)(4396001)(64706001)(50466002)(97736001)(86362001)(87936001)(80022001)(105586002)(46102001)(65956001)(44976005)(92566001)(83506001)(85852003)(79102001)(107046002)(106466001)(83322001)(101416001)(77982001)(54356999)(84676001)(87266999)(47776003)(74502001)(74662001)(21056001)(50986999)(81542001)(76176999)(68736004)(64126003)(83072002)(85306004)(81342001)(59896001)(575784001)(99396002)(65816999)(92726001)(2201001)(31966008)(65806001)(102836001)(19627235001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB039;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0304E36CA3
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2014 5:45 AM, Guenter Roeck wrote:
> On 08/14/2014 04:15 PM, Aravind Gopalakrishnan wrote:
>> This patch adds temperature monitoring support for F15h M60h processor.
>>   - Add new pci device id for the relevant processor
>>   - The functionality of REG_REPORTED_TEMPERATURE is moved to
>>     D0F0xBC_xD820_0CA4 [Reported Temperature Control]
>>     - So, use this to get CUR_TEMP value
>>     - Since we need an indirect register access, protect this with
>>       a mutex lock
>>   - Add Kconfig, Doc entries to indicate support for this processor.
>>
>> Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
>> ---
>> Changes in V3:
>>   - Move helper function that protects indirect register access locally
>>     until a time when others outside k10temp may need it
>>
>
> Applied, with a small change: I made the mutex and the new function 
> static.
> That can be changed if/when needed, and declaring it static now 
> ensures that
> we'll notice it. Likely the "next" user won't use the function anyway, 
> but
> that is a problem to sort out after it happens.
>

Ok, Thanks!
-Aravind.
