Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbaGQLsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:48:14 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:3016
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754868AbaGQLsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:48:11 -0400
X-WSS-ID: 0N8UU45-08-15S-02
X-M-MSG: 
Message-ID: <53C7B7EC.3070404@amd.com>
Date: Thu, 17 Jul 2014 14:47:56 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?windows-1252?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: Andrew Lewycky <Andrew.Lewycky@amd.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and pipes
 in KV
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <53C388F1.10606@daenzer.net> <53C38DAD.3060306@amd.com>
In-Reply-To: <53C38DAD.3060306@amd.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(199002)(189002)(24454002)(479174003)(92566001)(105586002)(36756003)(54356999)(85306003)(85852003)(101416001)(83072002)(81542001)(106466001)(81342001)(50466002)(92726001)(64706001)(87936001)(65816999)(87266999)(97736001)(23746002)(79102001)(99396002)(68736004)(95666004)(15202345003)(76176999)(15975445006)(47776003)(44976005)(20776003)(19580405001)(86362001)(19580395003)(33656002)(64126003)(83322001)(65806001)(31966008)(84676001)(74502001)(76482001)(77982001)(4396001)(21056001)(59896001)(83506001)(46102001)(102836001)(50986999)(80022001)(74662001)(107046002)(65956001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB039;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/07/14 10:58, Christian König wrote:
> Am 14.07.2014 09:38, schrieb Michel Dänzer:
>> On 11.07.2014 06:50, Oded Gabbay wrote:
>>> @@ -5876,8 +5871,13 @@ int cik_ib_parse(struct radeon_device *rdev, struct
>>> radeon_ib *ib)
>>>    */
>>>   int cik_vm_init(struct radeon_device *rdev)
>>>   {
>>> -    /* number of VMs */
>>> -    rdev->vm_manager.nvm = 16;
>>> +    /*
>>> +     * number of VMs
>>> +     * VMID 0 is reserved for Graphics
>>> +     * radeon compute will use VMIDs 1-7
>>> +     * KFD will use VMIDs 8-15
>>> +     */
>>> +    rdev->vm_manager.nvm = 8;
>> This comment is inaccurate: Graphics can use VMIDs 1-7 as well.
>
> Actually VMID 0 is reserved for system use and graphics operation only use VMIDs
> 1-7.
>
> Christian.
Will be fixed in v2 of the patchset

	Oded
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
