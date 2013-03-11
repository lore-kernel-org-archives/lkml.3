Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3CKOVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:21:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13099 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3CKOVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:21:17 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=4tJu7dT1YMoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=1YWbut8buxUA:10 a=i0EeH86SAAAA:8 a=hSgerHemiY4-lDQC3e0A:9 a=PUjeQqilurYA:10 a=hPjdaMEvmhQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363011675.12608.14.camel@gandalf.local.home>
Subject: Re: [PATCH 12/13] scsi/tracing: include correct header file
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Date: Mon, 11 Mar 2013 10:21:15 -0400
In-Reply-To: <513D844D.7000301@huawei.com>
References: <513D844D.7000301@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As you didn't include James in the header patch [0/13], he didn't see
you say:

"Two patches changed compilation on scsi subsystem, it should go through
to
SCSI tree."

In the future, send them as a separate patch series. There's no
dependencies on these patches with the rest of the series. They should
have been sent directly to James, with me as the Cc.

-- Steve


On Mon, 2013-03-11 at 15:14 +0800, zhangwei(Jovi) wrote:
> scsi_trace.c just export function scsi_trace_parse_cdb to
> event tracing infrastructure, It's not necessary to
> include trace/events/scsi.h
> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---
>  drivers/scsi/scsi_trace.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
> index 2bea4f0..b703256 100644
> --- a/drivers/scsi/scsi_trace.c
> +++ b/drivers/scsi/scsi_trace.c
> @@ -17,7 +17,7 @@
>   */
>  #include <linux/kernel.h>
>  #include <linux/trace_seq.h>
> -#include <trace/events/scsi.h>
> +#include <scsi/scsi.h>
> 
>  #define SERVICE_ACTION16(cdb) (cdb[1] & 0x1f)
>  #define SERVICE_ACTION32(cdb) ((cdb[8] << 8) | cdb[9])


