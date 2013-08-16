Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab3HPIAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:00:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3HPIAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:00:08 -0400
X-IronPort-AV: E=Sophos;i="4.89,893,1367942400"; 
   d="scan'208";a="8218139"
Message-ID: <520DDBB4.60801@cn.fujitsu.com>
Date: Fri, 16 Aug 2013 15:58:44 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        akpm@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/6] acpi cleanup: Use pr_info() instead of printk() in
 arch/x86/mm/srat.c
References: <1376636809-10159-1-git-send-email-tangchen@cn.fujitsu.com>  <1376636809-10159-4-git-send-email-tangchen@cn.fujitsu.com> <1376637949.1947.3.camel@joe-AO722>
In-Reply-To: <1376637949.1947.3.camel@joe-AO722>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/16 15:58:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/16 15:58:28,
	Serialize complete at 2013/08/16 15:58:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 08/16/2013 03:25 PM, Joe Perches wrote:
> On Fri, 2013-08-16 at 15:06 +0800, Tang Chen wrote:
>> arch/x86/mm/srat.c
>
> I think it'd be better to use pr_fmt
> with the conversions to pr_info and pr_err.
>
> pr_fmt can prefix the appropriate srat: and
> so the format strings do not need it.
>
> Something like:
> ---
>   arch/x86/mm/srat.c | 31 ++++++++++++++++---------------
>   1 file changed, 16 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
> index cdd0da9..350b4c5 100644
> --- a/arch/x86/mm/srat.c
> +++ b/arch/x86/mm/srat.c
> @@ -9,6 +9,8 @@
>    * are in one chunk. Holes between them will be included in the node.
>    */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

OK, will update the patches.

Thanks. :)

