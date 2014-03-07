Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaCGHZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 02:25:11 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:40364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaCGHZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 02:25:08 -0500
Message-ID: <1394177091.4653.1.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211: LLVMLinux: Remove VLAIS usage from mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: behanw@converseincode.com
Cc: linville@tuxdriver.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>,
        =?ISO-8859-1?Q?Vin=EDcius?= Tinti <viniciustinti@gmail.com>,
        Mark Charlebois <charlebm@gmail.com>
Date: Fri, 07 Mar 2014 08:24:51 +0100
In-Reply-To: <1394135570-26730-1-git-send-email-behanw@converseincode.com> (sfid-20140306_205408_313446_76872588)
References: <1394135570-26730-1-git-send-email-behanw@converseincode.com>
	 (sfid-20140306_205408_313446_76872588)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 11:52 -0800, behanw@converseincode.com wrote:
> From: Jan-Simon Möller <dl9pf@gmx.de>
> 
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent.

Fine, but

> +	char aead_req_data[sizeof(struct aead_request)
> +				+ crypto_aead_reqsize(tfm)
> +				+ CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;

You really should be using kernel coding style, which changes
indentation and has the + on the previous line.

> +	struct aead_request *aead_req
> +		= (struct aead_request *) aead_req_data;

(void *) is perfectly find and it'll probably fit on one line then.

> +	memset(&aead_req_data, 0, (sizeof(struct aead_request)+
> +		crypto_aead_reqsize(tfm) + CRYPTO_MINALIGN));

You don't need the size calculation again, you can use
sizeof(aead_req_data)

johannes

