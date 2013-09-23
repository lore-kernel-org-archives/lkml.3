Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3IWTjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:39:40 -0400
Received: from nm7-vm1.access.bullet.mail.bf1.yahoo.com ([216.109.114.160]:34014
	"EHLO nm7-vm1.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230Ab3IWTji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:39:38 -0400
X-Yahoo-Newman-Id: 613272.68562.bm@smtp119.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: r4GHixsVM1k00cadcEkV0ya5NdrvR0Ht8jOxuzOiE84HGyU
 U941x1xEzPkw7MHW7eR_FiPZq7fZHRc.BkL1xF.oVHUDMt16QrHWincYbKEZ
 NV3ecpHfiQ6LsTbpbvuPmp7roqeERw294ACDZ5uauH725jqMCn4C5l_u.6Lx
 UDguSTEbBy__IO0qSuHe0Wm3GybmqseLitQsCix8tx.fcDfQfX0Pe.cBv8wT
 ljTSCp0HI4RmOtdV.TTKxLCmRuf.wXo6wyJ__Vg2HnXsybUNESel0.QmrxHW
 qSor3idVrj1PG5C18SKFt.p8S4ZVCGePRl5kJe053JYwH7eXw9EIxBrITxu0
 ysbCnI2RwxUICuolYCJ_44iYPV5TP3eWl1jqeoiTZuduZIg3K9JtamRoitFq
 38ewMXBXJa9m6yKEuSo7cn9RBdhcZcZQSi0V9RC74hmiWe6uQh3zjh57ioP.
 zcuV8n3UlgfswdvKiAD2W.THY1sECMs5YzGkwgrHUiAAYJdiuiOXhp3JO2Y.
 SWu4RqFdTpiiU3Duuh_AjuCHOPadUEtAxC7AZZ4rmStC.WuWc_gJ6wAU5Z_i
 aL9EQEw--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with )
        by smtp119.sbc.mail.bf1.yahoo.com with SMTP; 23 Sep 2013 19:39:36 +0000 UTC
Message-ID: <52409917.2080506@att.net>
Date: Mon, 23 Sep 2013 14:40:07 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Daniel Santos <daniel.santos@pobox.com>,
        David Howells <dhowells@redhat.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 5/5] lib: Add error string support to printks
References: <1379482610.1787.7.camel@joe-AO722>  <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>  <1379459317-13046-6-git-send-email-daniel.santos@pobox.com>  <22238.1379502295@warthog.procyon.org.uk> <523A5316.50405@att.net>  <1379639226.5862.9.camel@joe-AO722> <523BDB55.2000008@att.net> <1379677551.2021.25.camel@joe-AO722>
In-Reply-To: <1379677551.2021.25.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 06:45 AM, Joe Perches wrote:
> On Fri, 2013-09-20 at 00:21 -0500, Daniel Santos wrote:
>
> [nice example about bloat]
>
>> Yeah, I do agree, I just don't see how to do it without introducing
>> unnecessary bloat.
> I think the code size cost of %pE is pretty trivial
> compared to the log size/runtime cost.

I suppose that would depend upon the conditions.  If no printks with 
error codes/names/messages are triggered, then the cost on the syslog is 
zero. Either way, we're already looking at adding one byte to the format 
string for the extra 'E' character and the 3-4 bytes for sign extend 
instruction would not exist on arm and most other archs.  I guess I'm 
usually trying to consider the memory constrained system where you 
wouldn't enable this feature but still suffer the sign extend bloat -- 
then again, I don't know of many embedded x86_64 systems. :)

> I would not want to see it used generically.

Hmm, I had considered this as a new mechanism to emit error codes to the 
ring buffer.  What sort of guidelines do you think are reasonable for 
when to use this proposed extension and when not to? Maybe on printks 
for error conditions that are most likely?

Daniel
