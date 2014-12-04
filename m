Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaLDM2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:28:09 -0500
Received: from mail-bl2on0111.outbound.protection.outlook.com ([65.55.169.111]:44448
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932078AbaLDM2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:28:07 -0500
X-WSS-ID: 0NG25AP-07-EB6-02
X-M-MSG: 
Message-ID: <54805340.9010003@amd.com>
Date: Thu, 4 Dec 2014 14:27:44 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: <airlied@linux.ie>, <alexander.deucher@amd.com>, <j.glisse@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <John.Bridgman@amd.com>, <Andrew.Lewycky@amd.com>, <joro@8bytes.org>
Subject: Re: [PATCH] amdkfd: use atomic allocations within srcu callbacks
References: <1417619976-8498-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1417619976-8498-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(41574002)(377454003)(479174003)(199003)(189002)(51704005)(24454002)(46102003)(50466002)(59896002)(117636001)(23676002)(50986999)(101416001)(99136001)(54356999)(65816999)(110136001)(102836001)(87266999)(92566001)(86362001)(92726001)(575784001)(21056001)(83506001)(76176999)(4396001)(64126003)(19580395003)(19580405001)(87936001)(84676001)(20776003)(47776003)(64706001)(105586002)(65806001)(106466001)(77156002)(62966003)(95666004)(97736003)(107046002)(99396003)(120916001)(77096005)(31966008)(68736005)(36756003)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601001);SRVR:BLUPR02MB195;
X-Forefront-PRVS: 041517DFAB
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/03/2014 05:19 PM, Sasha Levin wrote:
> srcu callbacks are running in atomic context, we can't allocate using
> __GFP_WAIT.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>   drivers/gpu/drm/amd/amdkfd/kfd_process.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
> index b4f49ac..b85eb0b 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
> @@ -196,7 +196,7 @@ static void kfd_process_destroy_delayed(struct rcu_head *rcu)
>   	mmdrop(p->mm);
>
>   	work = (struct kfd_process_release_work *)
> -		kmalloc(sizeof(struct kfd_process_release_work), GFP_KERNEL);
> +		kmalloc(sizeof(struct kfd_process_release_work), GFP_ATOMIC);
>
>   	if (work) {
>   		INIT_WORK((struct work_struct *) work, kfd_process_wq_release);
>

Thanks!
Applied to my -next tree.

Oded
