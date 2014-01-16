Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaAPASB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:18:01 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:23817 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaAPAR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:17:57 -0500
Message-ID: <1389831470.11912.40.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH net-next 2/2] reciprocal_divide: correction/update of
 the algorithm
From: Ben Hutchings <bhutchings@solarflare.com>
To: Daniel Borkmann <dborkman@redhat.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Austin S Hemmelgarn" <ahferroin7@gmail.com>,
        Jesse Gross <jesse@nicira.com>, "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        "Andy Gospodarek" <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@redhat.com>,
        "Jay Vosburgh" <fubar@us.ibm.com>,
        Jakub Zawadzki <darkjames-ws@darkjames.pl>
Date: Thu, 16 Jan 2014 00:17:50 +0000
In-Reply-To: <1389828228-30312-3-git-send-email-dborkman@redhat.com>
References: <1389828228-30312-1-git-send-email-dborkman@redhat.com>
	 <1389828228-30312-3-git-send-email-dborkman@redhat.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20432.004
X-TM-AS-Result: No--9.635400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 00:23 +0100, Daniel Borkmann wrote:
[...]
> --- a/include/linux/reciprocal_div.h
> +++ b/include/linux/reciprocal_div.h
[...]
> + * RECIPROCAL_VALUE_TO_ZERO can be used to express an element, which
> + * used as the argument to reciprocal_divide always yields zero.
>   */
[...]
> +#define RECIPROCAL_VALUE_RESULT_TO_ZERO ((struct reciprocal_value){.sh1 = 32})
[...]
> +static inline u32 reciprocal_divide(u32 a, struct reciprocal_value R)
>  {
> -	return (u32)(((u64)A * R) >> 32);
> +	u32 t = (u32)(((u64)a * R.m) >> 32);
> +	return (t + ((a - t) >> R.sh1)) >> R.sh2;
[...]

(a - t) has type u32.
So (a - t) >> 32 has undefined behaviour.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

