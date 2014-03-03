Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaCCONg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:13:36 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:38269 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaCCONf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:13:35 -0500
Message-ID: <53148E02.3060703@mev.co.uk>
Date: Mon, 3 Mar 2014 14:13:22 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: add timeouts to while loops in s626.c
References: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com> <5310C4CB.2060201@mev.co.uk> <1393652927.45628.YahooMailNeo@web164006.mail.gq1.yahoo.com> <1393733614.99805.YahooMailNeo@web164001.mail.gq1.yahoo.com>
In-Reply-To: <1393733614.99805.YahooMailNeo@web164001.mail.gq1.yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-02 04:13, Chase Southwood wrote:
>> On Friday, February 28, 2014 11:49 PM, Chase Southwood <chase.southwood@yahoo.com> wrote:
>
>>> On Friday, February 28, 2014 11:26 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
>>>> On 2014-02-28 07:35, Chase Southwood wrote:
>
> [snip]
>
>>> In the case of s626_send_dac(), it doesn't seem to be used in any
>>> critical sections, so it could make use of Hartley's comedi_timeout().
>>>
>>> Some of the timeout errors could be propagated, especially for
>>> s626_send_dac() which is only reachable from very few paths.
>>
>>
>> Awesome, I'll swap all of my timeouts out for comedi_timeout() in s626_send_dac().
>
> Actually, after taking another look at this, I don't think that using comedi_timeout()
> here is going to work, actually.
> The context from which s626_send_dac() is called allows sleep all right, but readl() isn't
> a comedi function and therefore it doesn't behave (in parameters or return values) as
> the callback function parameter to comedi_timeout() requires.  So unless I'm missing
> something particularly large here, I believe we'll have to do the timeouts here manually
> as well.  Am I correct here, and if so, would you like the iteration based timeouts here
> as well, or a sleep-based timeout similar to that employed by comedi_timeout()?

The readl() could be done in a small callback function.  As the 
different while loops are checking for different results from readl(), 
It would need a different callback functions for each case, or some 
creative use of the callback function's 'context' parameter.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
