Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3AWPEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:04:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20541 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3AWPEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:04:49 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=aeQPs-_SJuMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=N-VFlIc2aKAA:10 a=hHmAqNvhI3CydcFX9usA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358953487.21576.120.camel@gandalf.local.home>
Subject: Re: [PATCH 3.8-rc4-nohz3] kvm: Add missing EXPORT_SYMBOL when
 CONFIG_KVM=m
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: sedat.dilek@gmail.com, "devendra.aaru" <devendra.aaru@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 23 Jan 2013 10:04:47 -0500
In-Reply-To: <CAFTL4hzSvnE-b=TEvKcT3Jpwh4ZLPsMotCC7etpUeDDFNYOQBQ@mail.gmail.com>
References: <1358946905-13320-1-git-send-email-sedat.dilek@gmail.com>
	 <CAHdPZaNYFBXMhvH7Jyy5Zy4MnB3iKfL9UW9xf3jy5MNBu8aPnw@mail.gmail.com>
	 <CA+icZUW7XrOGguoPO00wxPLUr2Xc8fP=jQZwekpnmWKRewwX2g@mail.gmail.com>
	 <CAFTL4hzcuxoy2deQpXDBRQZZBZ4VjT=EnO3ZZv6x-jGMTr_eaA@mail.gmail.com>
	 <1358949189.21576.114.camel@gandalf.local.home>
	 <CAFTL4hzSvnE-b=TEvKcT3Jpwh4ZLPsMotCC7etpUeDDFNYOQBQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 15:02 +0100, Frederic Weisbecker wrote:

> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> index bbb2c2c..a13b8a3 100644
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -111,14 +111,19 @@ void guest_enter(void)
>         else
>                 __guest_enter();
>  }
> +EXPORT_SYMBOL_GPL(guest_enter);
> 
>  void guest_exit(void)
>  {
> +#ifndef CONFIG_KVM
> +i
> +#endif

I don't like #ifdefs in .c files. They belong in headers. Could you
convert this to be:

include/linux/context_tracking.h:

#ifdef CONFIG_KVM
 #define add_vi_i_typo()
#else
 #define add_vi_i_typo()	i
#endif

and then in context_tracking.c:

void guest_exit(void)
{
	add_vi_typo();

[...]

-- Steve

>         if (vtime_accounting_enabled())
>                 vtime_guest_exit(current);
>         else
>                 __guest_exit();
>  }
> +EXPORT_SYMBOL_GPL(guest_exit);
>  #endif


