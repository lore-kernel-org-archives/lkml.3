Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161Ab3BTLkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:40:09 -0500
Received: from hibox-130.abo.fi ([130.232.216.130]:56396 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757742Ab3BTLkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:40:07 -0500
Message-ID: <5124B613.6040400@hibox.fi>
Date: Wed, 20 Feb 2013 13:40:03 +0200
From: Marcus Sundman <marcus@hibox.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
References: <508DB432.2030208@hibox.fi> <20121101190119.GA27294@quack.suse.cz> <50932DAC.7040702@hibox.fi> <20121107161730.GB23654@quack.suse.cz> <509C4339.2090506@hibox.fi> <509D014B.2080709@hibox.fi> <20121113135159.GA18651@quack.suse.cz> <50A592BA.8050709@hibox.fi> <20121121233021.GA8730@quack.suse.cz> <50B4E6F2.6010000@hibox.fi> <20121205153216.GF5706@quack.suse.cz> <51248C5F.4040606@hibox.fi>
In-Reply-To: <51248C5F.4040606@hibox.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam_score: -2.7
X-Spam_bar: --
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.02.2013 10:42, Marcus Sundman wrote:
> On 05.12.2012 17:32, Jan Kara wrote:
>>    I see. Maybe you could have something like
>> while true; do echo w >/proc/sysrq-trigger; sleep 10; done
>>    running in the background?
>
> Sure, but I suspect it'll take until the worst is over before it 
> manages to load and execute that "echo w".

Here is a big run of sysrq-triggering, all while I was uncompressing a 
big rar file causing the whole system to be utterly unusable.
NB: Even with realtime I/O-priority the sysrq couldn't be triggered 
between 12:41:54 and 12:42:49, as you can see from the dmesg-3.txt file.

$ sudo ionice -c 1 su
# ionice
realtime: prio 4
# while true; do sleep 10; echo w >/proc/sysrq-trigger; done
^C
# tail -n +1700 /var/log/syslog >dmesg-3.txt

http://sundman.iki.fi/dmesg-3.txt


Regards,
Marcus
