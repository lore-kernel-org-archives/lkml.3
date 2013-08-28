Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3H1G1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:27:46 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:59813 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab3H1G1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:27:44 -0400
Date: Wed, 28 Aug 2013 08:27:37 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [guv v2 18/31] s390: Replace __get_cpu_var uses
Message-ID: <20130828062737.GA10394@osiris>
References: <20130826204351.725357339@linux.com>
 <00000140bc5f0c04-e8f49653-cc6a-4841-99ca-f89e07c359ed-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140bc5f0c04-e8f49653-cc6a-4841-99ca-f89e07c359ed-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082806-0542-0000-0000-000006432DE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 08:44:40PM +0000, Christoph Lameter wrote:
> __get_cpu_var() is used for multiple purposes in the kernel source. One of them is
> address calculation via the form &__get_cpu_var(x). This calculates the address for
> the instance of the percpu variable of the current processor based on an offset.


> 4. Retrieve the content of a percpu struct
> 
> 	DEFINE_PER_CPU(struct mystruct, y);
> 	struct mystruct x = __get_cpu_var(y);
> 
>    Converts to
> 
> 	memcpy(this_cpu_ptr(&y), x, sizeof(x));

That's wrong (destination and source should be exchanged).
However your patch looks good.

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

