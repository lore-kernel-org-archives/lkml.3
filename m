Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbaJXPOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:14:30 -0400
Received: from mail-bn1on0118.outbound.protection.outlook.com ([157.56.110.118]:16932
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756592AbaJXPO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:14:29 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Drivers: hv: util: make struct hv_do_fcopy match Hyper-V
 host messages
Thread-Topic: [PATCH] Drivers: hv: util: make struct hv_do_fcopy match Hyper-V
 host messages
Thread-Index: AQHP73QnbfRGLD8u20u7RcA+zQmUR5w/Ws4w
Date: Fri, 24 Oct 2014 15:14:25 +0000
Message-ID: <c05e07e89fff4419b8c6a545507067ec@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1414146027-1915-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1414146027-1915-1-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [131.107.147.105]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0374433C81
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(13464003)(377454003)(51704005)(107046002)(20776003)(33646002)(92566001)(46102003)(80022003)(86362001)(106116001)(86612001)(105586002)(106356001)(4396001)(31966008)(64706001)(76176999)(66066001)(76482002)(120916001)(50986999)(54356999)(97736003)(76576001)(95666004)(85306004)(19580405001)(101416001)(85852003)(77096002)(87936001)(2656002)(19580395003)(99396003)(21056001)(40100003)(122556002)(108616004)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Friday, October 24, 2014 3:20 AM
> To: linux-api@vger.kernel.org; KY Srinivasan
> Cc: Greg Kroah-Hartman; Jason Wang; linux-kernel@vger.kernel.org
> Subject: [PATCH] Drivers: hv: util: make struct hv_do_fcopy match Hyper-V
> host messages
> 
> An attempt to fix fcopy on i586 (bc5a5b0 Drivers: hv: util: Properly pack the
> data for file copy functionality) led to a regression on x86_64 (and actually
> didn't fix
> i586 breakage). Fcopy messages from Hyper-V host come in the following
> format:
> 
> struct do_fcopy_hdr   |   36 bytes
> 0000                  |    4 bytes
> offset                |    8 bytes
> size                  |    4 bytes
> data                  | 6144 bytes
> 
> On x86_64 struct hv_do_fcopy matched this format without '
> __attribute__((packed))'
> and on i586 adding ' __attribute__((packed))' to it doesn't change anything.
> Keep the structure packed and add padding to match re reality. Tested both
> i586 and x86_64 on Hyper-V Server 2012 R2.

Thanks Vitaly.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
> ---
>  include/uapi/linux/hyperv.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h index
> 0a8e6ba..bb1cb73 100644
> --- a/include/uapi/linux/hyperv.h
> +++ b/include/uapi/linux/hyperv.h
> @@ -134,6 +134,7 @@ struct hv_start_fcopy {
> 
>  struct hv_do_fcopy {
>  	struct hv_fcopy_hdr hdr;
> +	__u32   pad;
>  	__u64	offset;
>  	__u32	size;
>  	__u8	data[DATA_FRAGMENT];
> --
> 1.9.3

