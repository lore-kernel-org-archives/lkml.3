Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab3AOBSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 20:18:41 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61729 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab3AOBSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 20:18:40 -0500
Message-ID: <50F4AE6E.6080103@gmail.com>
Date: Mon, 14 Jan 2013 17:18:38 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: boot/compressed/mkpiggy.c: fix resource leakage
References: <1358187343-15752-1-git-send-email-dinggnu@gmail.com>
In-Reply-To: <1358187343-15752-1-git-send-email-dinggnu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 10:14 AM, Cong Ding wrote:
> the file should be closed if it goes to error.
>

What tool are you using to generate all these patches?


> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>   arch/x86/boot/compressed/mkpiggy.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
> index 958a641..e29154f 100644
> --- a/arch/x86/boot/compressed/mkpiggy.c
> +++ b/arch/x86/boot/compressed/mkpiggy.c
> @@ -58,6 +58,7 @@ int main(int argc, char *argv[])
>
>   	if (fread(&olen, sizeof(olen), 1, f) != 1) {
>   		perror(argv[1]);
> +		fclose(f);

The next line is a return from main().  All FILEs will be automatically 
closed by the C library, so your change is redundant.

The x86 maintainers can do what ever they want with it.  But to me, it 
seems like unnecessary code churn.

David Daney

>   		return 1;
>   	}
>
>

