Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaHDPEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:04:23 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:32054
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752415AbaHDPEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:04:21 -0400
X-WSS-ID: 0N9SF73-07-8PP-02
X-M-MSG: 
Message-ID: <53DFA0EB.5040302@amd.com>
Date: Mon, 4 Aug 2014 17:04:11 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>, <airlied@linux.ie>
CC: <thellstrom@vmware.com>, <nouveau@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <bskeggs@redhat.com>, <alexander.deucher@amd.com>
Subject: Re: [PATCH 09/19] drm/radeon: handle lockup in delayed work, v2
References: <20140731153245.15061.63023.stgit@patser>
 <20140731153342.15061.54264.stgit@patser> <53DBC1EC.1010001@amd.com>
 <53DBD269.80807@canonical.com> <53DF462B.2060102@amd.com>
 <53DF4A7D.3040505@canonical.com> <53DF7516.2010408@amd.com>
 <53DF8BF2.4000309@canonical.com> <53DF9AC4.3010700@amd.com>
 <53DF9B58.8000403@canonical.com> <53DF9C88.6060107@amd.com>
 <53DF9F89.60202@canonical.com>
In-Reply-To: <53DF9F89.60202@canonical.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [10.224.152.188]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(377424004)(199002)(189002)(51704005)(76482001)(36756003)(83322001)(44976005)(80316001)(87936001)(77982001)(64706001)(47776003)(20776003)(85182001)(79102001)(93886004)(65806001)(65956001)(64126003)(80022001)(86362001)(74662001)(74502001)(21056001)(4396001)(68736004)(101416001)(99396002)(33656002)(50986999)(84676001)(107046002)(97736001)(83506001)(31966008)(102836001)(23676002)(92566001)(92726001)(81342001)(85306004)(87266999)(54356999)(76176999)(50466002)(65816999)(106466001)(83072002)(81542001)(95666004)(46102001)(85202003)(85852003)(105586002);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB047;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0293D40691
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.08.2014 um 16:58 schrieb Maarten Lankhorst:
> op 04-08-14 16:45, Christian König schreef:
>> Am 04.08.2014 um 16:40 schrieb Maarten Lankhorst:
>>> op 04-08-14 16:37, Christian König schreef:
>>>>> It'a pain to deal with gpu reset.
>>>> Yeah, well that's nothing new.
>>>>
>>>>> I've now tried other solutions but that would mean reverting to the old style during gpu lockup recovery, and only running the delayed work when !lockup.
>>>>> But this meant that the timeout was useless to add. I think the cleanest is keeping the v2 patch, because potentially any waiting code can be called during lockup recovery.
>>>> The lockup code itself should never call any waiting code and V2 doesn't seem to handle a couple of cases correctly either.
>>>>
>>>> How about moving the fence waiting out of the reset code?
>>> What cases did I miss then?
>>>
>>> I'm curious how you want to move the fence waiting out of reset, when there are so many places that could potentially wait, like radeon_ib_get can call radeon_sa_bo_new which can do a wait, or radeon_ring_alloc that can wait on radeon_fence_wait_next, etc.
>> The IB test itself doesn't needs to be protected by the exclusive lock. Only everything between radeon_save_bios_scratch_regs and radeon_ring_restore.
> I'm not sure about that, what do you want to do if the ring tests fail? Do you have to retake the exclusive lock?

Just set need_reset again and return -EAGAIN, that should have mostly 
the same effect as what we are doing right now.

Christian.

>
> ~Maarten
>

