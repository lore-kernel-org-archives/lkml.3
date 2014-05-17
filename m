Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbaEQBzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 21:55:20 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:53435 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaEQBzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 21:55:18 -0400
Message-ID: <5376C17E.60403@gmail.com>
Date: Fri, 16 May 2014 19:55:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
CC: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, jolsa@redhat.com,
        namhyung.kim@kernel.org, Michael Lentine <mlentine@google.com>
Subject: Re: [PATCH 1/2] perf tools: add cat as fallback pager
References: <1400282087-4616-1-git-send-email-eranian@google.com> <1400282087-4616-2-git-send-email-eranian@google.com>
In-Reply-To: <1400282087-4616-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/14, 5:14 PM, Stephane Eranian wrote:
> From: Michael Lentine <mlentine@google.com>
>
> This patch adds a fallback to cat for the pager. This is useful
> on environmnents, such as Android, where less does not exist.
> It is better to default to cat than to abort.
>
> Reviewed-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Michael Lentine <mlentine@google.com>
> ---
>   tools/perf/util/pager.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
> index 3322b84..5feec3d 100644
> --- a/tools/perf/util/pager.c
> +++ b/tools/perf/util/pager.c
> @@ -57,13 +57,13 @@ void setup_pager(void)
>   	}
>   	if (!pager)
>   		pager = getenv("PAGER");
> -	if (!pager) {
> -		if (!access("/usr/bin/pager", X_OK))
> -			pager = "/usr/bin/pager";
> -	}
> -	if (!pager)
> +	if (!(pager || access("/usr/bin/pager", X_OK)))
> +		pager = "/usr/bin/pager";
> +	if (!(pager || access("/usr/bin/less", X_OK)))
>   		pager = "less";

If you check for /usr/bin/less shouldn't the full path be used here?

David
