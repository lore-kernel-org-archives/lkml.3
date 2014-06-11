Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaFKVya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:54:30 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:45883 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898AbaFKVy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:54:29 -0400
Message-ID: <5398D014.9020900@akamai.com>
Date: Wed, 11 Jun 2014 17:54:28 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Aristeu Rozanski <aris@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
References: <cover.1396645124.git.jbaron@akamai.com> <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com> <20140409113552.GJ6529@pd.tnic> <20140409133433.GJ29214@redhat.com> <3908561D78D1C84285E8C5FCA982C28F31E22EAC@ORSMSX106.amr.corp.intel.com> <20140409173633.GN6529@pd.tnic> <5345980F.7070604@akamai.com> <20140409191454.GQ6529@pd.tnic> <5345A54D.2050808@akamai.com> <20140409201615.GS6529@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F31E2358F@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31E2358F@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 05:33 PM, Luck, Tony wrote:
>> Unfortunately, the box reporting the ue errors just went into transit (so
>> that I can better examine this issue), so I will probably not be able to
>> run this experiment on that specific box until next week.
> 
> Do you have any other logs from this machine.  Is there something
> logged in one (or more) of the machine check banks when your EDAC
> driver says that there are uncorrected errors?
> 
> When the box is back  online again - I'd be interested to know if mcelog(8)
> daemon reports any errors.   Grab the latest from mcelog.org, compile
> and run as "mcelog --daemon".  Logs show up in /var/log/mcelog
> 

I finally got the bad dimm in hand - running the latest version
of mcelog, I don't see anything reported in the log. (I verified
that mcelog was reporting events via mce-inject.)


>> # ./rdmsr 0x179
>> c09
> 
> So this processor does support CMCI - next question is whether each
> bank support it (and got enabled by Linux) [can run on any system ... don't
> need to wait for the one to finish transit)]
> 
> # for I in `seq 0 8`
> do
>        ./rdmsr 0x28$i
> done
> 
> will print the MCi_CTL2 registers from each bank. Bit 30 (0x40000000)
> shows CMCI enabled.
> 
> On the name of the driver - can you throw in an underscore: ie3_12xx.c ?
> 
> Do you have systems from Sandy Bridge, Ivy Bridge and Haswell generations
> (no suffix for Sandy Bridge, then v2 and v3) ... and does this driver work across all of
> them?  If it is just for Haswell ... then "ie3_12xx_v3.c" might be a better name.
> 

So I've moved the dimm around to all three systems Sandy, Ivy Bridge and Haswell.
And this driver is populating '/sys/devices/system/edac/mc/mc0/ue_count' correctly
when a userspace memory scanning program also report errors. So the driver appears
to be doing the right thing.

I've tested:

CPU E3-1270 v3 @ 3.50GHz : 8086:0c08 (haswell)
CPU E3-1270 V2 @ 3.50GHz : 8086:0158 (ivy bridge)
CPU E31270 @ 3.40GHz : 8086:0108 (sandy bridge)

I still don't see any evidence of CMCI doing anything as the "THR" entry in
/proc/interrupts doesn't budge off of 0.

Let me know if you'd like me to look at anything else...

Thanks,

-Jason




 

