Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbbA2L1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:27:48 -0500
Received: from mail-by2on0062.outbound.protection.outlook.com ([207.46.100.62]:44672
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752378AbbA2L1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:27:45 -0500
X-AuditID: ac160a69-f79956d000002b3c-66-54ca192cb96f
Message-ID: <54CA1929.8060903@sandisk.com>
Date: Thu, 29 Jan 2015 12:27:37 +0100
From: Bart Van Assche <bart.vanassche@sandisk.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Jens Axboe <axboe@kernel.dk>, Sasha Levin <sasha.levin@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: Fix a recently introduced scsi-mq regression
References: <54C92A47.2030709@sandisk.com>
 <CACVXFVOtOujWH5jLLf16+-MeW--aiP1N14a=4aJP2h2_UVdtsw@mail.gmail.com>
In-Reply-To: <CACVXFVOtOujWH5jLLf16+-MeW--aiP1N14a=4aJP2h2_UVdtsw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI8azSFdH8lSIQUePrMXqu/1sFitXH2Wy
	uLxrDpvFroff2S0WH7nN7MDqMauhl83j8tlSj903G9g8Pj69xeLxeZNcAGsUl01Kak5mWWqR
	vl0CV8bsJr6CLRwVC1ZuYGxgfMjWxcjJISFgInFzViMzhC0mceHeeqA4F4eQwAlGiSUdL9gh
	nB2MEtNO7GaB6di44QuYLSSwhVGi5a4EiM0roCVxuXsZE4jNIqAq8XPqIzCbTcBI4tv7mWD1
	ogJhEt8372CGqBeUODnzCVhcBKh+Yv8/MJtZYCqjxNuXVSC2sICnxKtFv6F25Usc+7gG7GpO
	gUCJR/O3MHYxcgDVa0qs36UP0Sovsf3tHGaQmyUE9rJKbN32jQmiV13i5JL5TBMYRWYhWT0L
	oX0WkvYFjMyrGMVyM3OKc9NTCwyN9IoT81Iyi7P1kvNzNzGC44UrcwfjiknmhxgFOBiVeHgT
	Gk+GCLEmlhVX5h5ilOBgVhLhFRM4FSLEm5JYWZValB9fVJqTWnyIUZqDRUmcV3B6lr+QQHpi
	SWp2ampBahFMlomDU6qBcZHn9iUKrocS2pVZZM7yZDhI+5yPWxOt9/3Rqd11Ja/PvO1t6o94
	H/0+ctFLd9N/tzhZTnRvWB7LZdfIuH3ZtgrNuSVvJdyc8j4/1/WefmsGx6+pn+648uRyfpkl
	Pyvb7ucz5mmFM5u9HDzeZv3PD2QTFHz4vWlT7ZEFAdzrfj1yuX/4cNt8WSWW4oxEQy3mouJE
	ALPrgUmTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsXCtZEjRVdH8lSIwbsmXovVd/vZLFauPspk
	cXnXHDaLXQ+/s1ssPnKb2YHVY1ZDL5vH5bOlHrtvNrB5fHx6i8Xj8ya5ANYoLpuU1JzMstQi
	fbsErozZTXwFWzgqFqzcwNjA+JCti5GTQ0LARGLjhi8sELaYxIV768HiQgKbGCXWbCkHsXkF
	tCQudy9jArFZBFQlfk59BGazCRhJfHs/E6xXVCBM4vvmHcwQ9YISJ2c+AYuLANVP7P8HZHNx
	MAvMYJQ4dOkP2AJhAU+JV4t+s0Asy5c49nENWJxTIFDi0fwtjCA2s4C6xJ95l5ghbHmJ7W/n
	ME9g5J+FZMcsJGWzkJQtYGRexSiWm5lTnJueWWBopFecmJeSWZytl5yfu4kRHLacUTsYr080
	P8TIxMEp1cCYs1Dv89SdexqWznJY92RLcEjeDGFD3Y5Ls/yP7XTcfliqs71x1fGfNVFc8qrf
	mG7oSDv5XGWVWctTF1X/tM7J8/jnKY5vFaqcs959tdp5w1aq5l2SzYUiz8uegsn63CcL6zSD
	Ey+mbn6ulXc2Yf9GF7fe6QvNHd/zFjN+2czsdbVh2w6ZnitKLMUZiYZazEXFiQCIEjzECwIA
	AA==
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 63.163.107.173)
 smtp.mailfrom=Bart.VanAssche@sandisk.com; canonical.com; dkim=none (message
 not signed) header.d=none;canonical.com; dmarc=permerror action=none
 header.from=sandisk.com;
X-Forefront-Antispam-Report: CIP:63.163.107.173;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(377454003)(164054003)(51704005)(479174004)(24454002)(86362001)(33656002)(46102003)(36756003)(2950100001)(64126003)(62966003)(77156002)(50466002)(77096005)(19580405001)(87936001)(92566002)(23676002)(106466001)(110136001)(54356999)(50986999)(76176999)(47776003)(87266999)(65806001)(83506001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB116;H:milsmgep12.sandisk.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR02MB116;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB116;
X-Forefront-PRVS: 0471B73328
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB116;
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2015 11:27:40.8058
 (UTC)
X-MS-Exchange-CrossTenant-Id: fcd9ea9c-ae8c-460c-ab3c-3db42d7ac64d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fcd9ea9c-ae8c-460c-ab3c-3db42d7ac64d;Ip=[63.163.107.173]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB116
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/15 00:52, Ming Lei wrote:
> On Thu, Jan 29, 2015 at 2:28 AM, Bart Van Assche
> <bart.vanassche@sandisk.com> wrote:
>> This patch fixes a use-after-free that was introduced via patch
>> "blk-mq: fix hctx/ctx kobject use-after-free" (commit
>> 76d697d10769; kernel v3.19-rc4) and fixes the following crash:
> 
> Sorry, my fault, I shouldn't have linked mq's release with mq_kobj,
> which may be released before running blk_cleanup_queue().
> 
> Another approach may be to revert the faulty commit and release all
> mq stuff in request queue's release handler(blk_release_queue)
> which should be more safe and simple.

Hello Ming,

How important is the patch with commit ID 76d697d10769 ? Does it have to
be included in kernel v3.19 or can it be postponed until kernel v3.19.1
or kernel v3.19.2 ? If so, how about reverting that patch for kernel
v3.19 and sending a reworked patch to Jens with a "Cc: stable" tag after
the release of kernel v3.19 ? That last patch will then get included in
a stable version of kernel v3.19.

Thanks,

Bart.

