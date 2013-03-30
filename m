Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab3C3WHK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 18:07:10 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:32877 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab3C3WHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 18:07:08 -0400
Message-ID: <51576207.4090607@suse.cz>
Date: Sat, 30 Mar 2013 23:07:03 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd reclaims
 at each priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de> <1363525456-10448-2-git-send-email-mgorman@suse.de> <20130325090758.GO2154@dhcp22.suse.cz> <51501545.50908@suse.cz> <5154C4B6.102@suse.cz> <20130329082257.GB21227@dhcp22.suse.cz>
In-Reply-To: <20130329082257.GB21227@dhcp22.suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 09:22 AM, Michal Hocko wrote:
> On Thu 28-03-13 23:31:18, Jiri Slaby wrote:
>> On 03/25/2013 10:13 AM, Jiri Slaby wrote:
>>> BTW I very pray this will fix also the issue I have when I run ltp tests
>>> (highly I/O intensive, esp. `growfiles') in a VM while playing a movie
>>> on the host resulting in a stuttered playback ;).
>>
>> No, this is still terrible. I was now updating a kernel in a VM and had
>> problems to even move with cursor.
> 
> :/
> 
>> There was still 1.2G used by I/O cache.
> 
> Could you collect /proc/zoneinfo and /proc/vmstat (say in 1 or 2s
> intervals)?

Sure:
http://www.fi.muni.cz/~xslaby/sklad/zoneinfos.tar.xz

I ran the update like 10 s after I started taking snapshots. Mplayer
immediately started complaining:

           ************************************************
           **** Your system is too SLOW to play this!  ****
           ************************************************
etc.

thanks,
-- 
js
suse labs
