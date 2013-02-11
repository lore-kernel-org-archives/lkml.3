Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab3BKSux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:50:53 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65305 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759019Ab3BKSuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:50:50 -0500
Message-ID: <51193D86.3040507@vflare.org>
Date: Mon, 11 Feb 2013 10:50:46 -0800
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] zram: gather statistics in a unique file
References: <1360556946.4204.5.camel@buesod1.americas.hpqcorp.net> <20130211054117.GA31340@kroah.com> <1360606065.4204.10.camel@buesod1.americas.hpqcorp.net> <20130211181627.GA21390@kroah.com>
In-Reply-To: <20130211181627.GA21390@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 10:16 AM, Greg Kroah-Hartman wrote:
> On Mon, Feb 11, 2013 at 10:07:45AM -0800, Davidlohr Bueso wrote:
>> On Sun, 2013-02-10 at 21:41 -0800, Greg Kroah-Hartman wrote:
>>> On Sun, Feb 10, 2013 at 08:29:06PM -0800, Davidlohr Bueso wrote:
>>>> Instead of having one sysfs file per zram statistic, group them all
>>>> in a single, reader-friendly, 'statistics' file. This not only reduces
>>>> code but is also makes it easier to visualize. The new file looks like:
>>>>
>>>> Number of reads:        24
>>>> Number of writes:       1055
>>>> Invalid IO:             0
>>>> Notify free:            0
>>>> Zero pages:             1042
>>>> Orig data size:         49152 bytes
>>>> Compressed data:        838 bytes
>>>> Total memory used:      53248 bytes
>>>>
>>>> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
>>>
>>> No, please, the rule for sysfs is "one value per file", not files with
>>> lots of data that you need to parse.
>>
>> Ok.
>>
>>>
>>> If you want to do something like this, then do it in debugfs, but NEVER
>>> in sysfs.
>>
>> So, you would you be open to having the statistics file in debugfs and
>> removing the individual files sysfs?
>
> If these are merely debugging information, they should go to debugfs.
> If they are something that all users need/want, they should stay in
> sysfs as-is.
>

These zram statistics should stay in sysfs.

These stats could be used by userspace programs to trigger different 
actions. For instance, defrag%, calculated using compressed size and 
actual memory used, could be used to trigger defrag (not yet 
implemented).  Or low hit rates [number of reads/number of writes] is 
useful in determining is zram is really helpful or not, in case it's 
being used as swap. If not, zram should be unloaded or reset to save 
memory space.

Other than this, plain compression ratio stats along with zero_pages are 
also useful and not really debug info.

Though stats are spread across many files, it's easy to script them into 
a single view:

http://compcache.googlecode.com/git/sub-projects/scripts/zram_stats

I use this script to gather and display stats for each active zram device.

Thanks,
Nitin

