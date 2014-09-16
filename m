Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbaIPP45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:56:57 -0400
Received: from mail-by2on0113.outbound.protection.outlook.com ([207.46.100.113]:52096
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753750AbaIPP44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:56:56 -0400
X-WSS-ID: 0NC04AQ-07-OVR-02
X-M-MSG: 
Message-ID: <54185DC1.2060306@amd.com>
Date: Tue, 16 Sep 2014 10:56:49 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: <herrmann.der.user@googlemail.com>, <jdelvare@suse.de>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] hwmon, fam15h_power: Make actual power reporting
 conditional
References: <1410881918-1392-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20140916155221.GB14725@roeck-us.net>
In-Reply-To: <20140916155221.GB14725@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(164054003)(24454002)(479174003)(377454003)(51704005)(105586002)(106466001)(50466002)(76482001)(4396001)(33656002)(31966008)(90102001)(102836001)(85306004)(59896002)(95666004)(84676001)(21056001)(81542003)(46102003)(77982003)(83506001)(74502003)(65806001)(79102003)(80022003)(15975445006)(15202345003)(81342003)(97736003)(74662003)(110136001)(107046002)(99396002)(99136001)(87936001)(36756003)(92566001)(19580395003)(54356999)(83322001)(19580405001)(68736004)(50986999)(76176999)(65816999)(87266999)(23756003)(64126003)(65956001)(101416001)(44976005)(80316001)(86362001)(47776003)(92726001)(20776003)(85852003)(64706001)(15395725005)(83072002)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB491;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/16/2014 10:52 AM, Guenter Roeck wrote:
> On Tue, Sep 16, 2014 at 10:38:38AM -0500, Aravind Gopalakrishnan wrote:
>> power1_input should only be reported for Fam15h, Models 00h-0fh
>> So, introduce a is_visible function to take care of this.
>>
>> As suggested by Guenter here:
>> http://marc.info/?l=linux-kernel&m=141038145616437&w=2
>>
>> Suggested-by: Guenter Roeck <linux@roeck-us.net>
>> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
>> ---
>>   drivers/hwmon/fam15h_power.c | 19 ++++++++++++++++++-
>>   1 file changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
>> index 4a7cbfa..5ca24de 100644
>> --- a/drivers/hwmon/fam15h_power.c
>> +++ b/drivers/hwmon/fam15h_power.c
>> @@ -93,13 +93,30 @@ static ssize_t show_power_crit(struct device *dev,
>>   }
>>   static DEVICE_ATTR(power1_crit, S_IRUGO, show_power_crit, NULL);
>>   
>> +static umode_t fam15h_power_is_visible(struct kobject *kobj,
>> +				       struct attribute *attr,
>> +				       int index)
>> +{
>> +	/* power1_input is only reported for Fam15h, Models 00h-0fh */
>> +	if (!strcmp(attr->name, "power1_input") &&
> 	if (attr == &dev_attr_power1_input.attr &&
>
> works just as well and is simpler.

Ok.

>> +	   (boot_cpu_data.x86 != 0x15 || boot_cpu_data.x86_model > 0xf)) {
>> +		return 0;
>> +	}
>> +

I just noticed: I don't really need opening/closing parenthesis here. 
Shall fix and send V2.

>> +	return attr->mode;
>> +}
>> +
>>   

Thanks,
-Aravind.
