Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131AbaFCWzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:55:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41289 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbaFCWzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:55:12 -0400
Message-ID: <538E5249.2050305@infradead.org>
Date: Tue, 03 Jun 2014 15:55:05 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: "David S. Miller" <davem@davemloft.net>,
        Mathias Krause <minipli@googlemail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: connector: ucon.c:  Cleaning up file resource
 leak
References: <1401493578-20392-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1401493578-20392-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 04:46 PM, Rickard Strandqvist wrote:
> Cleaning up a file resource leak

The return (exit) closes all open files, so there is no resource leak.

OTOH, if someone were going to add this explicit close, then it should
be added in the other exit (return) paths also.

Not applied by the Documentation maintainer.

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  Documentation/connector/ucon.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/connector/ucon.c b/Documentation/connector/ucon.c
> index 8a4da64..f09c6de 100644
> --- a/Documentation/connector/ucon.c
> +++ b/Documentation/connector/ucon.c
> @@ -246,5 +246,7 @@ int main(int argc, char *argv[])
>  	}
>  
>  	close(s);
> +	if (stdout != out)
> +		fclose(out);
>  	return 0;
>  }
> 


-- 
~Randy
