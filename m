Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaGNH7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:59:03 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:8446
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751907AbaGNH6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:58:47 -0400
X-WSS-ID: 0N8OZHT-08-251-02
X-M-MSG: 
Message-ID: <53C38DAD.3060306@amd.com>
Date: Mon, 14 Jul 2014 09:58:37 +0200
From: =?windows-1252?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        Oded Gabbay <oded.gabbay@gmail.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: Andrew Lewycky <Andrew.Lewycky@amd.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        =?windows-1252?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and pipes
 in KV
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <53C388F1.10606@daenzer.net>
In-Reply-To: <53C388F1.10606@daenzer.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
X-Originating-IP: [10.224.155.44]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(24454002)(189002)(81342001)(44976005)(87266999)(92726001)(33656002)(97736001)(65816999)(92566001)(99396002)(54356999)(76176999)(102836001)(83072002)(85852003)(50986999)(76482001)(64706001)(80022001)(59896001)(47776003)(77982001)(20776003)(23746002)(83506001)(81542001)(65806001)(65956001)(36756003)(21056001)(85306003)(19580395003)(68736004)(83322001)(84676001)(101416001)(80316001)(74662001)(46102001)(105586002)(31966008)(95666004)(50466002)(87936001)(74502001)(106466001)(107046002)(86362001)(79102001)(4396001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB046;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.07.2014 09:38, schrieb Michel Dänzer:
> On 11.07.2014 06:50, Oded Gabbay wrote:
>> @@ -5876,8 +5871,13 @@ int cik_ib_parse(struct radeon_device *rdev, struct radeon_ib *ib)
>>    */
>>   int cik_vm_init(struct radeon_device *rdev)
>>   {
>> -	/* number of VMs */
>> -	rdev->vm_manager.nvm = 16;
>> +	/*
>> +	 * number of VMs
>> +	 * VMID 0 is reserved for Graphics
>> +	 * radeon compute will use VMIDs 1-7
>> +	 * KFD will use VMIDs 8-15
>> +	 */
>> +	rdev->vm_manager.nvm = 8;
> This comment is inaccurate: Graphics can use VMIDs 1-7 as well.

Actually VMID 0 is reserved for system use and graphics operation only 
use VMIDs 1-7.

Christian.
