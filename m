Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaANML7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:11:59 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:48394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaANML5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:11:57 -0500
Message-ID: <1389701498.23430.1.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH net-next 10/10] net: nl80211: __dev_get_by_index instead
 of dev_get_by_index to find interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Ying Xue <ying.xue@windriver.com>
Cc: davem@davemloft.net, vfalico@redhat.com, john.r.fastabend@intel.com,
        stephen@networkplumber.org, antonio@meshcoding.com,
        dmitry.tarnyagin@lockless.no, socketcan@hartkopp.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 14 Jan 2014 13:11:38 +0100
In-Reply-To: <1389685269-18600-11-git-send-email-ying.xue@windriver.com>
References: <1389685269-18600-1-git-send-email-ying.xue@windriver.com>
	 <1389685269-18600-11-git-send-email-ying.xue@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 15:41 +0800, Ying Xue wrote:

> @@ -2218,10 +2194,6 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>  			rdev->wiphy.coverage_class = old_coverage_class;
>  		}
>  	}
> -
> - bad_res:
> -	if (netdev)
> -		dev_put(netdev);
>  	return result;

I believe that could be "return 0;" now, which would make the code
easier to read.

johannes

