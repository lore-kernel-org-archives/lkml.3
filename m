Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbaGIWLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:11:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24157 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbaGIWLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:11:03 -0400
Message-ID: <53BDBDE7.8090600@oracle.com>
Date: Wed, 09 Jul 2014 18:10:47 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
CC: David Rientjes <rientjes@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: use after free in /proc/pid/mountinfo
References: <53B3F331.7090204@oracle.com>	<53B4CAB8.5070407@oracle.com>	<alpine.DEB.2.02.1407031434470.10658@chino.kir.corp.google.com>	<53B6C051.2060704@oracle.com>	<20140706100420.GB3589@osiris>	<20140709142406.GA27561@osiris> <20140709133138.c523aa03883be5417a4d19a4@linux-foundation.org>
In-Reply-To: <20140709133138.c523aa03883be5417a4d19a4@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 04:31 PM, Andrew Morton wrote:
> On Wed, 9 Jul 2014 16:24:06 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
>> > 058504edd026 ("fs/seq_file: fallback to vmalloc allocation") is suspected to
>> > cause a crash. Actually I can't reprocude the crash nor would I be able to
>> > tell how the commit could cause the crash.
>> > Anyway, I'll be offline for the next 2.5 weeks. So if Sasha could confirm
>> > that reverting the patch actually does fix the crash, please revert the
>> > commit, unless somebody else can make sense of the report of course.
>> > 
>> > I'm still wondering how Sasha could reproduce the crash.
> This really sucks :(
> 
> I suppose I'll queue up a revert of 058504edd026 as a for-3.16 bandaid.
> 
> Sasha, it would be great if you could delve a bit further into this,
> see if we can identify a way for others to reproduce the bug.
> 
> Did you test that little patchlet which Heiko sent?

I've been trying, but as there isn't an easy way to reproduce it, breakage
elsewhere in -next (there is a long list) is slowing me down. I'll revert
back to the -next where I've initially observed this issue and will retry.


Thanks,
Sasha
