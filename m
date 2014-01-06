Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaAFPMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:12:19 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:43011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaAFPMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:12:13 -0500
Message-ID: <1389021111.5891.21.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH v3.5 10/19] mac8011: slight optimization of addr compare
From: Johannes Berg <johannes@sipsolutions.net>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 06 Jan 2014 16:11:51 +0100
In-Reply-To: <52BC15C8.2080400@huawei.com>
References: <52BC15C8.2080400@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-26 at 19:40 +0800, Ding Tianhong wrote:
> Use the possibly more efficient ether_addr_equal
> to instead of memcmp.

This is a slow-path, I don't think that's really worth it. It kinda
makes sense, but relies on the struct mac_address allocation for
alignment and the fact that there are no other members in that struct,
so it seems to me that this ought to also add some alignment attributes?

johannes


