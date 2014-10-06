Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaJFJVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:21:47 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:9694 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149AbaJFJVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:21:45 -0400
X-IronPort-AV: E=Sophos;i="5.04,662,1406563200"; 
   d="scan'208";a="36858721"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: Richard Guy Briggs <rgb@redhat.com>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>
CC: "eparis@redhat.com" <eparis@redhat.com>,
        "pmoore@redhat.com" <pmoore@redhat.com>,
        "aviro@redhat.com" <aviro@redhat.com>,
        "sgrubb@redhat.com" <sgrubb@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: RE: [PATCH V5 08/13] sched: add a macro to ref all CLONE_NEW* flags
Thread-Topic: [PATCH V5 08/13] sched: add a macro to ref all CLONE_NEW* flags
Thread-Index: AQHP4SPWCumYcnmQrkml/y+T6huiCpwiyqHQ
Date: Mon, 6 Oct 2014 09:21:45 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5DABA4@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <cover.1412543112.git.rgb@redhat.com>
 <958367f30fb7eddaa406487e63ec1889138ef54f.1412543112.git.rgb@redhat.com>
In-Reply-To: <958367f30fb7eddaa406487e63ec1889138ef54f.1412543112.git.rgb@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s969Loeq005328



> -----Original Message-----
> From: containers-bounces@lists.linux-foundation.org
> [mailto:containers-bounces@lists.linux-foundation.org] On Behalf Of Richard Guy
> Briggs
> Sent: Monday, October 06, 2014 1:09 PM
> To: linux-audit@redhat.com; linux-kernel@vger.kernel.org;
> containers@lists.linux-foundation.org
> Cc: eparis@redhat.com; pmoore@redhat.com; aviro@redhat.com; sgrubb@redhat.com;
> ebiederm@xmission.com
> Subject: [PATCH V5 08/13] sched: add a macro to ref all CLONE_NEW* flags
> 
> ---
>  include/uapi/linux/sched.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> index 34f9d73..5aceba2 100644
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -28,6 +28,12 @@
>  #define CLONE_NEWUSER		0x10000000	/* New user namespace */
>  #define CLONE_NEWPID		0x20000000	/* New pid namespace */
>  #define CLONE_NEWNET		0x40000000	/* New network namespace */
> +#define CLONE_NEW_MASK	( CLONE_NEWNS \
> +			| CLONE_NEWUTS \
> +			| CLONE_NEWIPC \
> +			| CLONE_NEWUSER \
> +			| CLONE_NEWPID \
> +			| CLONE_NEWNET)	/* mask of all namespace type flags */
>  #define CLONE_IO		0x80000000	/* Clone io context */
> 

The name 'CLONE_NEW_MASK' may confuse readers.
How about something like CLONE_NEW_MASK_ALL?

Thanks,
- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
