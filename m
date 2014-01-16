Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaAPQhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:37:43 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:44315
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327AbaAPQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:37:41 -0500
Date: Thu, 16 Jan 2014 10:37:37 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Daniel Borkmann <dborkman@redhat.com>
cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Jesse Gross <jesse@nicira.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@redhat.com>, Jay Vosburgh <fubar@us.ibm.com>,
        Jakub Zawadzki <darkjames-ws@darkjames.pl>
Subject: Re: [PATCH net-next 2/2] reciprocal_divide: correction/update of
 the algorithm
In-Reply-To: <1389828228-30312-3-git-send-email-dborkman@redhat.com>
Message-ID: <alpine.DEB.2.10.1401161036110.29778@nuc>
References: <1389828228-30312-1-git-send-email-dborkman@redhat.com> <1389828228-30312-3-git-send-email-dborkman@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Daniel Borkmann wrote:

> - * or else the performance is slower than a normal divide.
> - */
> -extern u32 reciprocal_value(u32 B);
> +struct reciprocal_value {
> +	u32 m;
> +	u8 sh1, sh2;
> +};
>
> +#define RECIPROCAL_VALUE_RESULT_TO_ZERO ((struct reciprocal_value){.sh1 = 32})
>
> -static inline u32 reciprocal_divide(u32 A, u32 R)
> +struct reciprocal_value reciprocal_value(u32 d);

A function that returns a struct? That works? Which gcc versions support
it?


