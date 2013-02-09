Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab3BIWYk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 17:24:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45507 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab3BIWYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 17:24:39 -0500
Message-ID: <5116CC68.3090804@zytor.com>
Date: Sat, 09 Feb 2013 14:23:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 5/5] x86, head_32: Remove an old gcc2 fix
References: <1360439574-16122-1-git-send-email-bp@alien8.de> <1360439574-16122-6-git-send-email-bp@alien8.de> <af2ed3e1-3ac4-421c-b1a8-bfa243327ffb@email.android.com> <20130209212342.GA5556@pd.tnic>
In-Reply-To: <20130209212342.GA5556@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2013 01:23 PM, Borislav Petkov wrote:
> On Sat, Feb 09, 2013 at 12:52:01PM -0800, H. Peter Anvin wrote:
>> However... DF should have been cleared long before this...
>
> How about we do this at the beginning of default_entry where we clear
> EFLAGS too:
>
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index fc56613224c3..8b2a8a824fc6 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -322,10 +322,11 @@ default_entry:
>    * debugger if this code is traced. Best to initialize before switching to
>    * protected mode.
>    */
> -
>   	pushl $0
>   	popfl
>
> +	cld				# GCC wants DF=0 at all times
> +

The pushfl/popfl sequence clears DF too...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

