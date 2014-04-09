Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153AbaDIQV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:21:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47748 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354AbaDIQVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:21:19 -0400
Message-ID: <5345737E.4050008@infradead.org>
Date: Wed, 09 Apr 2014 09:21:18 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jonathan Callen <jcallen@gentoo.org>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/java.txt: add Java 7 support
References: <1396237634-6634-1-git-send-email-jcallen@gentoo.org>
In-Reply-To: <1396237634-6634-1-git-send-email-jcallen@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2014 08:47 PM, Jonathan Callen wrote:
> The sample wrapper currently fails on some Java 7 .class files.  This
> updates the wrapper to properly handle those files.
> 
> Signed-off-by: Jonathan Callen <jcallen@gentoo.org>

Applied.  Thanks.

How would I test this?


> ---
>  Documentation/java.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/java.txt b/Documentation/java.txt
> index e6a7232..4180205 100644
> --- a/Documentation/java.txt
> +++ b/Documentation/java.txt
> @@ -188,6 +188,9 @@ shift
>  #define CP_METHODREF 10
>  #define CP_INTERFACEMETHODREF 11
>  #define CP_NAMEANDTYPE 12
> +#define CP_METHODHANDLE 15
> +#define CP_METHODTYPE 16
> +#define CP_INVOKEDYNAMIC 18
>  
>  /* Define some commonly used error messages */
>  
> @@ -242,14 +245,19 @@ void skip_constant(FILE *classfile, u_int16_t *cur)
>  		break;
>  	case CP_CLASS:
>  	case CP_STRING:
> +	case CP_METHODTYPE:
>  		seekerr = fseek(classfile, 2, SEEK_CUR);
>  		break;
> +	case CP_METHODHANDLE:
> +		seekerr = fseek(classfile, 3, SEEK_CUR);
> +		break;
>  	case CP_INTEGER:
>  	case CP_FLOAT:
>  	case CP_FIELDREF:
>  	case CP_METHODREF:
>  	case CP_INTERFACEMETHODREF:
>  	case CP_NAMEANDTYPE:
> +	case CP_INVOKEDYNAMIC:
>  		seekerr = fseek(classfile, 4, SEEK_CUR);
>  		break;
>  	case CP_LONG:
> 


-- 
~Randy
