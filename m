Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaLPIyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:54:12 -0500
Received: from box2.japko.eu ([91.121.152.53]:52022 "EHLO box2.japko.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbaLPIyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:54:11 -0500
Date: Tue, 16 Dec 2014 09:53:58 +0100
From: Krzysztof Adamski <k@japko.eu>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: Use ether_addr_copy() in
 vnt_fill_ieee80211_rts.
Message-ID: <20141216085357.GB14666@box2.japko.eu>
References: <20141216083021.GA14666@box2.japko.eu>
 <1418719326.2674.32.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1418719326.2674.32.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:42:06AM -0800, Joe Perches wrote:
>On Tue, 2014-12-16 at 09:30 +0100, Krzysztof Adamski wrote:
>> Both struct ieee80211_rts and struct ieee80211_hdr defined in
>> linux/ieee80211.h are declared as __aligned(2) so it is safe to use
>> ether_addr_copy() instead of memcpy().
>
>Just fyi:
>
>That the structure is declared __aligned(2) is not
>the important bit.  What's necessary is that the
>members in the struct are __aligned(2).
>
>In this case, all of these members are.

Hi,

Thank you for your feedback. Yes, you are right. It was a bit of a 
shortcut in my reasoning.  Since struct is aligned and it's packed and 
both members preceding the array we want to copy are 16 bit large, the 
array address is guaranteed to be properly aligned.

Best regards,
Krzysztof Adamski
