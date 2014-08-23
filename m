Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaHWSBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 14:01:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:34471 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaHWSBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 14:01:07 -0400
Message-ID: <53F8D6DD.90306@infradead.org>
Date: Sat, 23 Aug 2014 11:01:01 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ganesh Rapolu <ganesh.rapolu@hotmail.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] DOCUMENTATION: Fixed typo in an example in memory-barriers.txt
References: <BLU436-SMTP214DCCF4135E3E81A493210E2D10@phx.gbl>
In-Reply-To: <BLU436-SMTP214DCCF4135E3E81A493210E2D10@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/14 23:05, Ganesh Rapolu wrote:
> In the first example in the memory-barriers.txt file, CPU 2 is assigned to
> run (x = B; y = A;). However, the rest of the example proceeds as if CPU 2 had been
> running (x = A; y = B;) as shown by the descriptions of the possible executions:
> 
> 	STORE A=3,	STORE B=4,	x=LOAD A->3,	y=LOAD B->4
> 	STORE A=3,	STORE B=4,	y=LOAD B->4,	x=LOAD A->3
> 	STORE A=3,	x=LOAD A->3,	STORE B=4,	y=LOAD B->4
> 	STORE A=3,	x=LOAD A->3,	y=LOAD B->2,	STORE B=4
> 	STORE A=3,	y=LOAD B->2,	STORE B=4,	x=LOAD A->3
> 	STORE A=3,	y=LOAD B->2,	x=LOAD A->3,	STORE B=4
> 	STORE B=4,	STORE A=3,	x=LOAD A->3,	y=LOAD B->4
> 	STORE B=4, ...
> 	...
> 
> The change was merely to make the inital evironment consistent with what happens in the
> rest of the example.
> 
> Signed-off-by: Ganesh Rapolu <ganesh.rapolu@hotmail.com>


Comments David, Alexey, Andrew, Paul?

This would revert Alexey's patch 615cc2c9cf9529846fbc342560d6787c2ccaaeea:
"Documentation/memory-barriers.txt: fix important typo re memory barriers"
that was merged on June 6, 2014.

Thanks.


> ---
>  Documentation/memory-barriers.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index a4de88f..9a46bbe 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -115,8 +115,8 @@ For example, consider the following sequence of events:
>  	CPU 1		CPU 2
>  	===============	===============
>  	{ A == 1; B == 2 }
> -	A = 3;		x = B;
> -	B = 4;		y = A;
> +	A = 3;		x = A;
> +	B = 4;		y = B;
>  
>  The set of accesses as seen by the memory system in the middle can be arranged
>  in 24 different combinations:
> 


-- 
~Randy
