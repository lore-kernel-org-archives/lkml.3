Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbbAOQ76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:59:58 -0500
Received: from mail-bl2on0102.outbound.protection.outlook.com ([65.55.169.102]:7571
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751437AbbAOQ7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:59:55 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: RE: [PATCH v4] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Topic: [PATCH v4] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Index: AQHQL9YUbH8z7Bc+R0CCwE2yyndNYpzBaVCA
Date: Thu, 15 Jan 2015 16:59:52 +0000
Message-ID: <BY2PR0301MB071109BC1EBB1521A03567ECA04E0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1421229310-15563-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1421229310-15563-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0710;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-forefront-prvs: 0457F11EAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(377454003)(13464003)(51704005)(74316001)(86612001)(76176999)(50986999)(1511001)(54356999)(54606007)(66066001)(54206007)(2421001)(2501002)(64706001)(86362001)(2900100001)(107886001)(46102003)(102836002)(68736005)(99286002)(2950100001)(19580405001)(19580395003)(106116001)(105586002)(106356001)(33656002)(92566002)(2656002)(40100003)(2561002)(551934003)(87936001)(76576001)(217423001)(77156002)(62966003)(101416001)(122556002)(97736003)(2201001)(21314002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2015 16:59:52.4810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0710
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui [mailto:decui@microsoft.com]
> Sent: Wednesday, January 14, 2015 1:55 AM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; vkuznets@redhat.com
> Cc: KY Srinivasan
> Subject: [PATCH v4] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> 
> In the case the user-space daemon crashes, hangs or is killed, we need to
> down the semaphore, otherwise, after the daemon starts next time, the
> obsolete data in fcopy_transaction.message or fcopy_transaction.fcopy_msg
> will be used immediately.
> 
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> ---
> 
> v2: I removed the "FCP" prefix as Greg asked.
> 
>     I also updated the output message a little:
>     "FCP: failed to acquire the semaphore" -->
>     "can not acquire the semaphore: it is benign"
> 
> v3: I added the code in fcopy_release() as Jason Wang suggested.
>     I removed the pr_debug (it isn't so meaningful)and added a comment
> instead.
> 
> v4: this is a resend of v3, plus adding a comment before
>     fcopy_release().
> ---
>  drivers/hv/hv_fcopy.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c index
> 23b2ce2..cd453e4 100644
> --- a/drivers/hv/hv_fcopy.c
> +++ b/drivers/hv/hv_fcopy.c
> @@ -86,6 +86,18 @@ static void fcopy_work_func(struct work_struct
> *dummy)
>  	 * process the pending transaction.
>  	 */
>  	fcopy_respond_to_host(HV_E_FAIL);
> +
> +	/* In the case the user-space daemon crashes, hangs or is killed, we
> +	 * need to down the semaphore, otherwise, after the daemon starts
> next
> +	 * time, the obsolete data in fcopy_transaction.message or
> +	 * fcopy_transaction.fcopy_msg will be used immediately.
> +	 *
> +	 * NOTE: fcopy_read() happens to get the semaphore (very rare)?
> We're
> +	 * still OK, because we've reported the failure to the host.
> +	 */
> +	if (down_trylock(&fcopy_transaction.read_sema))
> +		;
> +
>  }
> 
>  static int fcopy_handle_handshake(u32 version) @@ -344,6 +356,14 @@
> static int fcopy_open(struct inode *inode, struct file *f)
>  	return 0;
>  }
> 
> +/* XXX: there are still some tricky corner cases, e.g.,
> + * 1) In a SMP guest, when fcopy_release() runs between
> + * schedule_delayed_work() and fcopy_send_data(), there is
> + * still a chance an obsolete message will be queued.
> + *
> + * 2) When the fcopy daemon is running, if we unload the driver,
> + * we'll notice a kernel oops when we kill the daemon later.
> + */
>  static int fcopy_release(struct inode *inode, struct file *f)  {
>  	/*
> @@ -351,6 +371,13 @@ static int fcopy_release(struct inode *inode, struct
> file *f)
>  	 */
>  	in_hand_shake = true;
>  	opened = false;
> +
> +	if (cancel_delayed_work_sync(&fcopy_work)) {
> +		/* We haven't up()-ed the semaphore(very rare)? */
> +		if (down_trylock(&fcopy_transaction.read_sema))
> +			;
> +		fcopy_respond_to_host(HV_E_FAIL);
> +	}
>  	return 0;
>  }
> 
> --
> 1.9.1

