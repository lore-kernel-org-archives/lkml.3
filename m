Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab3ILNZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:25:56 -0400
Received: from hibox-130.abo.fi ([130.232.216.130]:46645 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab3ILNZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:25:55 -0400
X-Greylist: delayed 1689 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2013 09:25:55 EDT
Message-ID: <5231BA3C.2090704@hibox.fi>
Date: Thu, 12 Sep 2013 15:57:32 +0300
From: Marcus Sundman <marcus@hibox.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
References: <20121121233021.GA8730@quack.suse.cz> <50B4E6F2.6010000@hibox.fi> <20121205153216.GF5706@quack.suse.cz> <51248C5F.4040606@hibox.fi> <5124B613.6040400@hibox.fi> <20130222205144.GA30600@quack.suse.cz> <5127FEEA.60207@hibox.fi> <20130224001222.GB5551@dastard> <20130224012052.GC1196@thunk.org> <512D01E0.7010009@hibox.fi> <20130226231703.GA22674@quack.suse.cz>
In-Reply-To: <20130226231703.GA22674@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam_score: -2.7
X-Spam_bar: --
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.02.2013 01:17, Jan Kara wrote:
> On Tue 26-02-13 20:41:36, Marcus Sundman wrote:
>> On 24.02.2013 03:20, Theodore Ts'o wrote:
>>> On Sun, Feb 24, 2013 at 11:12:22AM +1100, Dave Chinner wrote:
>>>>>> /dev/sda6 /home ext4 rw,noatime,discard 0 0
>>>>                                     ^^^^^^^
>>>> I'd say that's your problem....
>>> Looks like the Sandisk U100 is a good SSD for me to put on my personal
>>> "avoid" list:
>>>
>>> http://thessdreview.com/our-reviews/asus-zenbook-ssd-review-not-necessarily-sandforce-driven-shows-significant-speed-bump/
>>>
>>> There are a number of SSD's which do not implement "trim" efficiently,
>>> so these days, the recommended way to use trim is to run the "fstrim"
>>> command out of crontab.
>> OK. Removing 'discard' made it much better (the 60-600 second
>> freezes are now 1-50 second freezes), but it's still at least an
>> order of magnitude worse than a normal HD. When writing, that is --
>> reading is very fast (when there's no writing going on).
>>
>> So, after reading up a bit on this trimming I'm thinking maybe my
>> filesystem's block sizes don't match up with my SSD's blocks (or
>> whatever its write unit is called). Then writing a FS block would
>> always write to multiple SSD blocks, causing multiple
>> read-erase-write sequences, right? So how can I check this, and how
>> can I make the FS blocks match the SSD blocks?
>    As Ted wrote, alignment isn't usually a problem with SSDs. And even if it
> was, it would be at most a factor 2 slow down and we don't seem to be at
> that fine grained level :)
>
> At this point you might try mounting the fs with nobarrier mount option (I
> know you tried that before but without discard the difference could be more
> visible), switching IO scheduler to CFQ (for crappy SSDs it actually isn't
> a bad choice), and we'll see how much we can squeeze out of your drive...

I repartitioned the drive and reinstalled ubuntu and after that it 
gladly wrote over 100 MB/s to the SSD without any hangs. However, after 
a couple of months I noticed it had degraded considerably, and it keeps 
degrading. Now it's slowly becoming completely unusable again, with 
write speeds of the magnitude 1 MB/s and dropping.

As far as I can tell I have not made any relevant changes. Also, the 
amount of free space hasn't changed considerably, but it seems that the 
longer it's been since I reformatted the drive the more free space is 
required for it to perform well.

So, maybe the cause is fragmentation? I tried running e4defrag and then 
fstrim, but it didn't really help (well, maybe a little bit, but after a 
couple of days it was back in unusable-land). Also, "e4defrag -c" gives 
a fragmenation score of less than 5, so...

Any ideas?


Best regards,
Marcus
