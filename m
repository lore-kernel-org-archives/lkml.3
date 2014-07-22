Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaGVJPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:15:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49352 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaGVJPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:15:51 -0400
Date: Tue, 22 Jul 2014 12:14:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julian Anastasov <ja@ssi.bg>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, dcb314@hotmail.com,
        David Miller <davem@davemloft.net>, kadlec@blackhole.kfki.hu,
        Patrick McHardy <kaber@trash.net>, pablo@netfilter.org,
        Simon Horman <horms@verge.net.au>, wensong@linux-vs.org
Subject: Re: [PATCH 3/5] net/netfilter/ipvs/ip_vs_ctl.c: drop argument range
 check just before the check for equality
Message-ID: <20140722091441.GN18338@mwanda>
References: <1405697638-23767-1-git-send-email-andrey.krieger.utkin@gmail.com>
 <alpine.LFD.2.11.1407182339160.2273@ja.home.ssi.bg>
 <CANZNk83dJCXAWrQ+i5rh=sdUuiiD5ZhzDua-rjJpBZCzzNGDJA@mail.gmail.com>
 <alpine.LFD.2.11.1407212253100.2358@ja.home.ssi.bg>
 <20140722074214.GL25880@mwanda>
 <alpine.LFD.2.11.1407221136420.1949@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1407221136420.1949@ja.home.ssi.bg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 11:52:02AM +0300, Julian Anastasov wrote:
> > > -	if (copylen > 128)
> > > +	if (*len < (int) copylen || *len < 0) {
> > > +		pr_err("get_ctl: len %d < %u\n", *len, copylen);
> > 
> > Don't let users flood dmesg.  Just return an error.  (This can be
> > triggered by non-root as well).
> 
> 	For now both set and get are privileged operations,
> so we can keep it, it can catch if something wrong happens
> with the structure sizes.

If you have namespaces enabled then it's not *that* privaleged.

regards,
dan carpenter

