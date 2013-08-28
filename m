Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3H1Tfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:35:36 -0400
Received: from mail.tpi.com ([74.45.170.26]:54362 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab3H1Tff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:35:35 -0400
X-Greylist: delayed 1567 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2013 15:35:34 EDT
Message-ID: <521E4AE6.7080703@canonical.com>
Date: Wed, 28 Aug 2013 13:09:26 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH net-next 1/1] net: neighbour: Simplify ifdefs around neigh_app_ns()
References: <1377714286-51816-1-git-send-email-tim.gardner@canonical.com> <1377715873.1928.47.camel@joe-AO722>
In-Reply-To: <1377715873.1928.47.camel@joe-AO722>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 12:51 PM, Joe Perches wrote:
> On Wed, 2013-08-28 at 12:24 -0600, Tim Gardner wrote:
>> Drop a couple of ifdef/endif pairs by moving the ifdef
>> surrounding neigh_app_ns() to the interior of neigh_app_ns().
> []
>> This is an admittedly trivial change. I stumbled on it while trying to figure
>> out why Ubuntu doesn't have CONFIG_ARPD enabled.
> 
> I'd be more inclined to make neigh_app_ns static inline
> in the .h file and remove the EXPORT_SYMBOL
> 

I thought about that as well, but then you'd have to extern
__neigh_notify(), which is currently a static function and large enough
to not really be suitable for inlining. Seems like unnecessary churn to me.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
