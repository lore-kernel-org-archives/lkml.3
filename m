Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889AbaHGQrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:47:15 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43755 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaHGQrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:47:14 -0400
Message-ID: <53E3AEE4.1080100@gmail.com>
Date: Thu, 07 Aug 2014 18:52:52 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] Add the "verbose" module option.
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it>	<1407359103-6012-4-git-send-email-kreijack@inwind.it>	<1407401555.4314.14.camel@chaos.site>	<53E3A963.4080807@inwind.it> <20140807184316.6682aa98@endymion.delvare>
In-Reply-To: <20140807184316.6682aa98@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 06:43 PM, Jean Delvare wrote:
> On Thu, 07 Aug 2014 18:29:23 +0200, Goffredo Baroncelli wrote:
>> On 08/07/2014 10:52 AM, Jean Delvare wrote:
>>> Le Wednesday 06 August 2014 à 21:05 +0000, Goffredo Baroncelli a écrit :
>>>> +	 */
>>>> +	tempchanged = x.temp != temp || x.casetemp != casetemp;
>>>> +	if ((verbose > 1 && tempchanged) ||
>>>> +	    (verbose > 0 && level >= 0)) {
>>>> +		printk(KERN_INFO);
>>>> +		print_temp("CPU-temp: ", temp);
>>>
>>> This can be written more efficiently as a single statement:
>>>
>>> 		print_temp(KERN_INFO "CPU-temp: ", temp);
>>
>> I suppose that KERN_* has to be in the beginning of the line. 
> 
> Correct.
> 
>> Because a single line is composed by several prink,
> 
> In this case, it is, but FYI, this is generally discouraged. The reason
> is that another piece of the kernel may be calling printk at the same
> time, and then that other message may split your own message into
> pieces. If you run checkpatch.pl on this file, you'll see it complains
> about this.
> 
>> KERN_INFO has 
>> to be only in the first printk. To me it seems more polite to have
>> one printk for the level, and the others (there are more than one) 
>> for the message parts.
> 
> The fewer printks is better. Ideally there would be only one to avoid
> the risk of line splitting altogether. I understand this isn't easy to
> achieve in this case, but I still believe that you shouldn't have more
> calls to printk than necessary, to reduce the risk.
> 
Ok, now I understand the reason. I will remove the first printk.

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
