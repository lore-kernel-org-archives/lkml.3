Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbaCLG6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:58:47 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:34178 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbaCLG6k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:58:40 -0400
Date: Wed, 12 Mar 2014 07:58:37 +0100
From: Christian Riesch <christian.riesch@omicron.at>
To: Richard Cochran <richardcochran@gmail.com>,
        =?UTF-8?Q?S=C3=B8rensen=2C?= <Stefan.Sorensen@spectralink.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, davem@davemloft.net
Subject: Re: [PATCH RFC net-next v1 0/9] ptp: dynamic pin control
Message-ID: <E9E8485F5E84770575AD1FAB@[172.22.2.41]>
In-Reply-To: <20140310134227.GB19781@netboy>
References: <cover.1394307303.git.richardcochran@gmail.com>
 <1394455974.2296.22.camel@e37108.spectralink.com>
 <20140310134227.GB19781@netboy>
X-Mailer: Mulberry/4.0.8 (Win32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

--On March 10, 2014 14:42 +0100 Richard Cochran <richardcochran@gmail.com> 
wrote:

> On Mon, Mar 10, 2014 at 12:52:57PM +0000, Sørensen, Stefan wrote:
>>
>> What are the n_ext_ts and n_per_out supposed to be set to now? The
>> number of pins configured for the relevant function or the number of
>> channels that are available for the function?
>
> They are the number of available functions. This is not necessarily the
> same as the number of pins. Many chips have more functions than pins.
>
>> The implementation is limited to a single function for each pin - the
>> dp83640 supports an ext_ts and several periodic outputs on the same pin,
>> but I do not see that many real-world uses.
>
> Yes, it does support different functions on a single pin, but not at
> the same time.  You have to choose what function you want on each pin,
> and that is what the new ioctl lets you do.
>
> I did not change the n_per_out in this series,

Why not? I think it would be a good idea to set both n_ext_ts and n_per_out 
to the correct value right from the start (8, right?).
Christian

> but once this basic
> support gets merged, then you will be able to increase n_per_out for
> the dp83640 with little extra effort.
