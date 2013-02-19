Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab3BSCjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:39:09 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:53104 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab3BSCjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:39:08 -0500
Subject: Re: [PATCH] acer-wmi: do not use 'devices' uninitialized
From: joeyli <jlee@suse.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1359033178.1325.15.camel@x61.thuisdomein>
References: <1359033178.1325.15.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Feb 2013 10:38:14 +0800
Message-ID: <1361241494.6635.2.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul, 

Sorry for I am late to reply your patch.

於 四，2013-01-24 於 14:12 +0100，Paul Bolle 提到：
> Commit f20aaba9819d0801fb1314363f97239da0100bac ("acer-wmi: fix obj is
> NULL but dereferenced") introduced a GCC warning:
>     drivers/platform/x86/acer-wmi.c: In function ‘acer_wmi_init’:
>     drivers/platform/x86/acer-wmi.c:1216:14: warning: ‘devices’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>     drivers/platform/x86/acer-wmi.c:1193:6: note: ‘devices’ was declared here
> 
> GCC is correct. In WMID_set_capabilities() there are now clearly codepaths
> that use 'devices' uninitialized. (WMID_set_capabilities() is apparently
> inlined in acer_wmi_init().) Previously that couldn't happen. So rework
> the code to use the previous logic, but also make sure 'obj' will not be
> dereferenced while NULL.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Zhang Rui sent similar patch for fix the warning:
http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg04016.html


Still appreciate for your contribution!


Thanks a lot!
Joey Lee

> ---
> Compile tested only!
> 
>  drivers/platform/x86/acer-wmi.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index afed701..0ddac19 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -1197,14 +1197,12 @@ static acpi_status WMID_set_capabilities(void)
>  		return status;
>  
>  	obj = (union acpi_object *) out.pointer;
> -	if (obj) {
> -		if (obj->type == ACPI_TYPE_BUFFER &&
> +	if (obj && obj->type == ACPI_TYPE_BUFFER &&
>  			(obj->buffer.length == sizeof(u32) ||
>  			obj->buffer.length == sizeof(u64))) {
>  			devices = *((u32 *) obj->buffer.pointer);
> -		} else if (obj->type == ACPI_TYPE_INTEGER) {
> +	} else if (obj && obj->type == ACPI_TYPE_INTEGER) {
>  			devices = (u32) obj->integer.value;
> -		}
>  	} else {
>  		kfree(out.pointer);
>  		return AE_ERROR;


