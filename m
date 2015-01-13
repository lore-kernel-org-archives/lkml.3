Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbbAMONJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:13:09 -0500
Received: from lists.s-osg.org ([54.187.51.154]:49366 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbbAMONG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:13:06 -0500
Message-ID: <54B527E8.3080004@osg.samsung.com>
Date: Tue, 13 Jan 2015 07:12:56 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tim Mester <ttmesterr@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] media: au0828 remove video and vbi buffer timeout
 work-around
References: <cover.1421115389.git.shuahkh@osg.samsung.com> <515f84cc1e6e33f647610f1bda154127944e6b52.1421115389.git.shuahkh@osg.samsung.com> <CAGoCfixdyOJoyUQfMWzM2KHjMGJE5pRS8C0+rR1nDCir7jTpwQ@mail.gmail.com>
In-Reply-To: <CAGoCfixdyOJoyUQfMWzM2KHjMGJE5pRS8C0+rR1nDCir7jTpwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 09:44 PM, Devin Heitmueller wrote:
> Hi Shuah,
> 
> On Mon, Jan 12, 2015 at 9:56 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>> au0828 does video and vbi buffer timeout handling to prevent
>> applications such as tvtime from hanging by ensuring that the
>> video frames continue to be delivered even when the ITU-656
>> input isn't receiving any data. This work-around is complex
>> as it introduces set and clear timer code paths in start/stop
>> streaming, and close interfaces. However, tvtime will hang
>> without the following tvtime change:
> 
> I'm confused.  When we last debated whether this patch would be
> accepted, the last message from Mauro said the following:
> 
>> That means that we'll need to keep holding such timeout code for
>> years, until all distros update to a new tvtime, of course assuming
>> that this is the only one application with such issue.
> 
> In other words, the timeout code has to stay in there since otherwise
> it will cause ABI breakage.  It's great that Hans has submitted a
> patch to improve tvtime, and over the next couple of years that patch
> might actually start to appear in distributions.  That unfortunately
> doesn't change the fact that everybody who updates their kernel (or
> has it updated for them as part of their distribution) will go from
> "works fine" to "completely broken".
> 
> The driver was working before the VB2 conversion, so if there is now
> instability then it's likely that some bug was introduced during the
> conversion to VB2.  Simply ripping out the timeout code seems like the
> wrong approach to addressing a regression likely caused by your own
> VB2 conversion patch.
> 

I couldn't reproduce what I was seeing when I did patch v2 series
work. What I noticed was that I was seeing a few too many green screens
and I had to re-tune xawtv when the timeout code is in place. My
thinking was that this timeout handling could be introducing blank
green frames when there is no need. However, I can't reproduce the
problem on 3.19-rc4 base which is what I am using to test the changes
to the patch series. Hence, I am not positive if the timeout code
indeed was doing anything bad.

I am seeing tvtime hangs without the timeout. I am fine with this
patch not going. It does make the code cleaner and also reduces
buffer handling during streaming. However, there is a clear regression
to tvtime.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
