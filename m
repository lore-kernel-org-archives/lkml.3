Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaCJNme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:42:34 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43458 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaCJNmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:42:33 -0400
Date: Mon, 10 Mar 2014 14:42:27 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: =?iso-8859-1?B?U/hyZW5zZW4s?= Stefan 
	<Stefan.Sorensen@spectralink.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhutchings@solarflare.com" <bhutchings@solarflare.com>,
        "christian.riesch@omicron.at" <christian.riesch@omicron.at>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v1 0/9] ptp: dynamic pin control
Message-ID: <20140310134227.GB19781@netboy>
References: <cover.1394307303.git.richardcochran@gmail.com>
 <1394455974.2296.22.camel@e37108.spectralink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394455974.2296.22.camel@e37108.spectralink.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 12:52:57PM +0000, Sørensen, Stefan wrote:
> 
> What are the n_ext_ts and n_per_out supposed to be set to now? The
> number of pins configured for the relevant function or the number of
> channels that are available for the function?

They are the number of available functions. This is not necessarily the
same as the number of pins. Many chips have more functions than pins.

> The implementation is limited to a single function for each pin - the
> dp83640 supports an ext_ts and several periodic outputs on the same pin,
> but I do not see that many real-world uses. 

Yes, it does support different functions on a single pin, but not at
the same time.  You have to choose what function you want on each pin,
and that is what the new ioctl lets you do.

I did not change the n_per_out in this series, but once this basic
support gets merged, then you will be able to increase n_per_out for
the dp83640 with little extra effort.

Thanks,
Richard
