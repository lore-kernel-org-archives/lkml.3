Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630Ab3DIRA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:00:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760264Ab3DIRAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:00:55 -0400
Date: Tue, 9 Apr 2013 13:00:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] x86, kdump: Change crashkernel_high/low= to
 crashkernel=;high/low
Message-ID: <20130409170017.GK6320@redhat.com>
References: <1365113821-22749-1-git-send-email-yinghai@kernel.org>
 <1365113821-22749-5-git-send-email-yinghai@kernel.org>
 <20130409134544.GA6320@redhat.com>
 <b591d6e4-5468-48f1-8b7e-c6a3943214cd@email.android.com>
 <20130409164720.GJ6320@redhat.com>
 <51644698.2010203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51644698.2010203@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 09:49:28AM -0700, H. Peter Anvin wrote:
> On 04/09/2013 09:47 AM, Vivek Goyal wrote:
> > On Tue, Apr 09, 2013 at 08:00:57AM -0700, H. Peter Anvin wrote:
> >> Please, no semicolons. We already have established syntax for suboptions (option=suboption,suboption,...) and suboptions with parameters (option=suboption:value,...)
> > 
> > Ok, to understand it better, so crashkernel= will look as follows?
> > 
> > crashkernel=suboption[,suboption[,....]][@offset]
> > 
> > A suboption can be.
> > 
> > - A memory value (128[KMG])
> > - A range with value (range:size)
> > - Or a property influencing memory allocation behavior (e.g high or low)
> > 
> > If yes, sounds good.
> > 
> 
> Sorry, I don't quite grok @offset and range:size here.
> 
> What exactly does those bits do?

We have following crashkernel= syntax defined in kernel-parameters.txt.

        crashkernel=range1:size1[,range2:size2,...][@offset]
                        [KNL] Same as above, but depends on the memory
                        in the running system. The syntax of range is
                        start-[end] where start and end are both
                        a memory unit (amount[KMG]). See also
                        Documentation/kdump/kdump.txt for an example.


Because memory required for filtering depended on existing RAM in the
box, somebody came with this syntax. "range" specifies the range of
memory present in the system and "value" represents how much RAM
to reserve if system RAM falls in the range.

For example (From kdump.txt)

crashkernel=512M-2G:64M,2G-:128M

This would mean:

    1) if the RAM is smaller than 512M, then don't reserve anything
       (this is the "rescue" case)
    2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
    3) if the RAM size is larger than 2G, then reserve 128M
 

Thanks
Vivek
