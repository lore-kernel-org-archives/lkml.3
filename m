Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbbA2Mtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:49:41 -0500
Received: from mail-bl2on0060.outbound.protection.outlook.com ([65.55.169.60]:4937
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751599AbbA2Mtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:49:39 -0500
X-AuditID: ac160a69-f79956d000002b3c-54-54ca2c5b6433
Message-ID: <54CA2C59.2090607@sandisk.com>
Date: Thu, 29 Jan 2015 13:49:29 +0100
From: Bart Van Assche <bart.vanassche@sandisk.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@fb.com>,
        <linux-kernel@vger.kernel.org>
CC: Christoph Hellwig <hch@lst.de>, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 2/2] blk-mq: release mq's kobjects in blk_release_queue()
References: <1422533847-31726-1-git-send-email-ming.lei@canonical.com>
 <1422533847-31726-3-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1422533847-31726-3-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI8azSDda51SIwclVahb/9xxjs1i5+iiT
	xeVdc9gsdj38zm6x+MhtZgdWj1kNvWweE5vfsXvsvtnA5vHx6S0Wj8+b5AJYo7hsUlJzMstS
	i/TtErgybp+4z1qwjqXi2qUG1gbGg8xdjJwcEgImElcOrIayxSQu3FvP1sXIxSEkcIJRYmnz
	GlYIZwejxL/PVxhhOo7sWMMCkdjCKDF3zkygFg4OXgEtiXeNESAmi4CqxJoeVpByNgEjiW/v
	Z7KA2KICYRLfN+8AW8YrIChxcuYTsLiIQJLElwNzwGxmAQ+J1p03wWxhAV+Jbd+amSBWNTJK
	9Bx4CtbMKeAu0fByLRtEg4HEkUVzWCFseYntb+dAfXOQVeL5+kQQW0hAXeLkkvlMExhFZiHZ
	PQtJ+ywk7QsYmVcxiuVm5hTnpqcWGBrpFSfmpWQWZ+sl5+duYgRHDVfmDsYVk8wPMQpwMCrx
	8CY0ngwRYk0sK67MPcQowcGsJMJbqHQqRIg3JbGyKrUoP76oNCe1+BCjNAeLkjiv4PQsfyGB
	9MSS1OzU1ILUIpgsEwenVAMjl88E0QWhnofq75uKe+3eXHf+pq/I/2D9FRJPtPhmNQcseTjx
	2lEWTlEd19XSU9inR/a+ztANe/CkdRnXSSWeVff2GavvPPl4Tu7UhNqcQz8Olci2Hrzz/YuU
	IT/Lzot2in9Wzck1uW+y632u98H2zyszEwoDdsmodpyJeLxZ7/C9bc+uTspZpcRSnJFoqMVc
	VJwIACZB0SyWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJJMWRmVeSWpSXmKPExsXCtZEjRTda51SIwYseaYv/e46xWaxcfZTJ
	4vKuOWwWux5+Z7dYfOQ2swOrx6yGXjaPic3v2D1232xg8/j49BaLx+dNcgGsUVw2Kak5mWWp
	Rfp2CVwZt0/cZy1Yx1Jx7VIDawPjQeYuRk4OCQETiSM71rBA2GISF+6tZ+ti5OIQEtjEKLHv
	4WMgh4ODV0BL4l1jBIjJIqAqsaaHFaScTcBI4tv7mWCtogJhEt837wAbySsgKHFy5hOwuIhA
	osSKSZ1gNrOAh0TrzptgtrCAr8S2b81MEKsaGSV6DjwFa+YUcJdoeLmWDaJBT2LH9V+sELa8
	xPa3c5gnMPLPQrJjFpKyWUjKFjAyr2IUy83MKc5NzywwNNQrTsxLySzO1kvOz93ECA5czsgd
	jE8nmh9iZOLglGpgPPS/ZK356vR5p163W28KF/0yu0aJefUBF/ENHDGHnq5+NMPMI974juer
	P3ez2t88aWTluqW/T8Ix8WPw0VQ+MY3CjNKss8uvKm+2Dyx87ZixO7fpjkz+ChdHH+aV93KD
	mCvPF5oePHRqndDZslnfG3o+bnzx9Xaac3i19kT+0BUFSVdit37rVmIpzkg01GIuKk4EAPdZ
	H2gMAgAA
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 63.163.107.173)
 smtp.mailfrom=Bart.VanAssche@sandisk.com; canonical.com; dkim=none (message
 not signed) header.d=none;canonical.com; dmarc=permerror action=none
 header.from=sandisk.com;
X-Forefront-Antispam-Report: CIP:63.163.107.173;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(479174004)(51704005)(51914003)(24454002)(50466002)(33656002)(77156002)(62966003)(106466001)(87936001)(92566002)(23746002)(54356999)(87266999)(50986999)(76176999)(65806001)(65956001)(46102003)(2950100001)(77096005)(83506001)(47776003)(36756003)(64126003);DIR:OUT;SFP:1101;SCL:1;SRVR:CO1PR02MB127;H:milsmgep12.sandisk.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:CO1PR02MB127;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB127;
X-Forefront-PRVS: 0471B73328
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB127;
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2015 12:49:32.1013
 (UTC)
X-MS-Exchange-CrossTenant-Id: fcd9ea9c-ae8c-460c-ab3c-3db42d7ac64d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fcd9ea9c-ae8c-460c-ab3c-3db42d7ac64d;Ip=[63.163.107.173]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB127
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/15 13:18, Ming Lei wrote:
> The kobject memory inside blk-mq hctx/ctx shouldn't have been freed
> before the kobject is released because driver core can access it freely
> before its release.
> 
> We can't do that in all ctx/hctx/mq_kobj's release handler because
> it can be run before blk_cleanup_queue().
> 
> Given mq_kobj shouldn't have been introduced, this patch simply moves
> mq's release into blk_release_queue().

Thanks for the quick respin. With these two patches applied my test
passes (SRP SCSI host removal).

Bart.

