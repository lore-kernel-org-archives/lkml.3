Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236Ab3JPQxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:53:41 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:12394 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761065Ab3JPQxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:53:39 -0400
X-AuditID: cbfec372-b7fe76d000003347-35-525ec4922fa5
Date: Wed, 16 Oct 2013 13:53:32 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/9] ACPI, APEI,
 CPER: Fix status check during error printing
Message-id: <20131016135332.0884f535@samsung.com>
In-reply-to: <1381935366-11731-2-git-send-email-gong.chen@linux.intel.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/hYN1JR+KCDDp+yli0nfjNZvF5wz82
	i1vvbC1m33/MYrF8Xz+jxeVdc9gs7rc8Zbd4c+EeiwOHx/fWPhaPxXteMnnMOxno8eDQZhaP
	L6uuMXu833eVzePzJrkA9igum5TUnMyy1CJ9uwSujPdX7zAWPOKo+Pf5FFsD4wz2LkZODgkB
	E4k7i55A2WISF+6tZ+ti5OIQEljCKHF87jd2CKebSeJS9zc2kCoWAVWJ+S+eMIHYbAJGEq8a
	W1hBbBEBHYkHm1YzgjQwC6xilHjzZjtYQlggTOLDppksIDavgKHEjo2/GEFsTgEvic7t+5kh
	NnQySsw5vgFoHQfQHU4SW6f6QtQLSvyYfA+sl1lAS2LztiZWCFteYvOat8wTGAVmISmbhaRs
	FpKyBYzMqxhFS4uTC4qT0nMN9YoTc4tL89L1kvNzNzFCYqBoB+OzDVaHGAU4GJV4eGcsjwsS
	Yk0sK67MPcQowcGsJML7aStQiDclsbIqtSg/vqg0J7X4ECMTB6dUA+NincPlXKz/duXqrz3F
	8lH8frTxa8O3Qj+XniwxUfd8nn39268Tc8KMv9q+/zU5/kjf4WqZC29UF81fvk6+0sCrfddr
	S6W96addzsdP5/ltaaex6G6E/eyIGZNY5MpNQxqkngqtXHHggOsk9m/yse49ar/OHpXoa9T7
	/0b9dP5kjqvx30Kkfd8rsRRnJBpqMRcVJwIAYuWxN18CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 16 Oct 2013 10:55:58 -0400
"Chen, Gong" <gong.chen@linux.intel.com> escreveu:

> Commit aaf9d93 only catches condition check before print,
> but the similar check is needed during printing CPER error
> sections.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> Reviewed-by: Borislav Petkov <bp@suse.de>

Reviewed-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> ---
>  drivers/acpi/apei/cper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index 33dc6a0..f827f02 100644
> --- a/drivers/acpi/apei/cper.c
> +++ b/drivers/acpi/apei/cper.c
> @@ -353,7 +353,7 @@ void apei_estatus_print(const char *pfx,
>  	       cper_severity_str(severity));
>  	data_len = estatus->data_length;
>  	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
> -	while (data_len > sizeof(*gdata)) {
> +	while (data_len >= sizeof(*gdata)) {
>  		gedata_len = gdata->error_data_length;
>  		apei_estatus_print_section(pfx, gdata, sec_no);
>  		data_len -= gedata_len + sizeof(*gdata);


-- 

Cheers,
Mauro
