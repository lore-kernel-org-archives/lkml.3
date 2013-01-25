Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab3AYQCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:02:00 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:63470 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3AYQB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:01:58 -0500
Date: Fri, 25 Jan 2013 13:01:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [perf PATCH 3/3] Fix double fclose() on do_write(fd, xxx) failure
Message-ID: <20130125160151.GA31242@ghostprotocols.net>
References: <2684910.12iLzy42t4@storm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2684910.12iLzy42t4@storm>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 25, 2013 at 11:22:17AM +0100, Thomas Jarosch escreveu:
> cppcheck reported:
> [util/header.c:983]: (error) Used file that is not opened.
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> ---
>  tools/perf/util/header.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 7b24cf3..30745c2 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -955,6 +955,7 @@ static int write_topo_node(int fd, int node)
>  	}
>  
>  	fclose(fp);
> +	fp = NULL;

Ok, but what is the behaviour of fclose(NULL)? Is it defined?

- Arnaldo
