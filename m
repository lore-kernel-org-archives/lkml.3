Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754Ab3BZSlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:41:52 -0500
Received: from hibox-130.abo.fi ([130.232.216.130]:54353 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab3BZSlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:41:51 -0500
Message-ID: <512D01E0.7010009@hibox.fi>
Date: Tue, 26 Feb 2013 20:41:36 +0200
From: Marcus Sundman <marcus@hibox.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
References: <20121113135159.GA18651@quack.suse.cz> <50A592BA.8050709@hibox.fi> <20121121233021.GA8730@quack.suse.cz> <50B4E6F2.6010000@hibox.fi> <20121205153216.GF5706@quack.suse.cz> <51248C5F.4040606@hibox.fi> <5124B613.6040400@hibox.fi> <20130222205144.GA30600@quack.suse.cz> <5127FEEA.60207@hibox.fi> <20130224001222.GB5551@dastard> <20130224012052.GC1196@thunk.org>
In-Reply-To: <20130224012052.GC1196@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam_score: -2.7
X-Spam_bar: --
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.02.2013 03:20, Theodore Ts'o wrote:
> On Sun, Feb 24, 2013 at 11:12:22AM +1100, Dave Chinner wrote:
>>>> /dev/sda6 /home ext4 rw,noatime,discard 0 0
>>                                     ^^^^^^^
>> I'd say that's your problem....
> Looks like the Sandisk U100 is a good SSD for me to put on my personal
> "avoid" list:
>
> http://thessdreview.com/our-reviews/asus-zenbook-ssd-review-not-necessarily-sandforce-driven-shows-significant-speed-bump/
>
> There are a number of SSD's which do not implement "trim" efficiently,
> so these days, the recommended way to use trim is to run the "fstrim"
> command out of crontab.

OK. Removing 'discard' made it much better (the 60-600 second freezes 
are now 1-50 second freezes), but it's still at least an order of 
magnitude worse than a normal HD. When writing, that is -- reading is 
very fast (when there's no writing going on).

So, after reading up a bit on this trimming I'm thinking maybe my 
filesystem's block sizes don't match up with my SSD's blocks (or 
whatever its write unit is called). Then writing a FS block would always 
write to multiple SSD blocks, causing multiple read-erase-write 
sequences, right? So how can I check this, and how can I make the FS 
blocks match the SSD blocks?

Best regards,
Marcus

