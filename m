Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaCCOG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:06:26 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:38250 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbaCCOGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:06:25 -0500
Message-ID: <53148C2A.9000305@mev.co.uk>
Date: Mon, 3 Mar 2014 14:05:30 +0000
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
References: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com> <5310C4CB.2060201@mev.co.uk> <1393652927.45628.YahooMailNeo@web164006.mail.gq1.yahoo.com>
In-Reply-To: <1393652927.45628.YahooMailNeo@web164006.mail.gq1.yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-01 05:48, Chase Southwood wrote:
> On Friday, February 28, 2014 11:26 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
>> On 2014-02-28 07:35, Chase Southwood wrote:
>>> And finally, are timeouts here even necessary or helpful, or are there
>>> any better ways to do it?
>>
>> In the case of s626_send_dac(), it doesn't seem to be used in any
>> critical sections, so it could make use of Hartley's comedi_timeout().
>>
>> Some of the timeout errors could be propagated, especially for
>> s626_send_dac() which is only reachable from very few paths.
>>
>
> Awesome, I'll swap all of my timeouts out for comedi_timeout() in s626_send_dac().
> As for propagating the timeout errors, could you please clarify that a bit further?  Both of the functions
> which I add timeouts inside of in this patch return void, and so in their current state they cannot return any error
> values.  Would you like them (or at least s626_send_dac()) to instead return an error upon timeout/or success on success,
> or am I just totally misunderstanding your meaning of propagate here?

s626_send_dac() could be changed to return an int value 0 on success or 
-ETIMEDOUT on timeout.  s626_set_dac() and s626_write_trim_dac() could 
be changed to return an int - just return the result of s626_send_dac(). 
  Similarly, the result of those functions could be either propagated 
upwards.  This could all be done in a separate patch (or patches).

>> There are other infinite loops involving calls to the s626_mc_test()
>> function, but those could be dealt with by other patches.
>
> Yeah, I saw those...I'll whip up a patch for them, just wanted to verify that everything looks pretty good here
> before I started on that.  I'll have that right out!

Yes, anything is an improvement on an infinite loop waiting for the 
hardware to do something!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
