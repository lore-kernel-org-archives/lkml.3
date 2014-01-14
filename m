Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaANSwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:52:47 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37322 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaANSwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:52:42 -0500
Message-ID: <52D58785.6000407@kernel.org>
Date: Tue, 14 Jan 2014 18:52:53 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Marek Vasut <marex@denx.de>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] iio: mxs-lradc: fix invalid channel number detection
References: <1389628923-8689-1-git-send-email-alexandre.belloni@free-electrons.com> <1389628923-8689-3-git-send-email-alexandre.belloni@free-electrons.com> <201401132125.37243.marex@denx.de> <52D47A12.7000807@free-electrons.com>
In-Reply-To: <52D47A12.7000807@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13/01/14 23:43, Alexandre Belloni wrote:
> On 13/01/2014 21:25, Marek Vasut wrote:
>> On Monday, January 13, 2014 at 05:02:02 PM, Alexandre Belloni wrote:
>>> 16 would be accepted as a channel number but it is invalid. It doesn't
>>> really have any effect as mxs_lradc_read_raw is called from a "controlled"
>>> environment so it it only gets values going from 0 to 15.
>>>
>>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>>
>> Why don't you remove the check entirely then ?
>>
>
> I'm not quite sure the inkernel API is sanitizing the input correctly
> but maybe I didn't check enough. Maybe Jonathan can comment ?
>
Unless we have a bug (more than possible as this stuff isn't heavily used
yet), it should be impossible to get the required reference to a channel
that doesn't exist.  Thus I don't 'think' the check is needed.  Feel free
to write a test case to prove me wrong ;)

Jonathan
