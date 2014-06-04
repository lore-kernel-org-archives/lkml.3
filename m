Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaFDVjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:39:35 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:58464 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFDVjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:39:33 -0400
MIME-Version: 1.0
In-Reply-To: <1401917100-2584-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401917100-2584-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 4 Jun 2014 14:39:32 -0700
X-Google-Sender-Auth: Dtc38f81Qw8WVia6im4jAdvRKr8
Message-ID: <CAGXu5j+S6x-TjDYpooHMQyrLHuMYb0fHMH6H9ZiVCwEWm-Gw+w@mail.gmail.com>
Subject: Re: [PATCH] Documentation: accounting: getdelays.c: Cleaning up
 missing null-terminate after strncpy call
From: Kees Cook <keescook@chromium.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 2:25 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Added a guaranteed null-terminate after call to strncpy.
>
> This was partly found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  Documentation/accounting/getdelays.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
> index c6a06b7..f405780 100644
> --- a/Documentation/accounting/getdelays.c
> +++ b/Documentation/accounting/getdelays.c
> @@ -314,6 +314,7 @@ int main(int argc, char *argv[])
>                         break;
>                 case 'm':
>                         strncpy(cpumask, optarg, sizeof(cpumask));
> +                       cpumask[sizeof(cpumask) - 1] = '\0';
>                         maskset = 1;
>                         printf("cpumask %s maskset %d\n", cpumask, maskset);
>                         break;
> --
> 1.7.10.4
>

Yup, looks right. Thanks for the patch! Luckily this is just example code. :)

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
