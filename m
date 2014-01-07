Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaAGOsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:48:33 -0500
Received: from ks35366.kimsufi.com ([213.251.186.122]:59147 "EHLO meetr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbaAGOsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:48:25 -0500
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 09:48:25 EST
To: Ramkumar Ramachandra <artagnon@gmail.com>
Subject: Re: [PATCH 0/4] Get EDID late for VGA switcheroo
X-PHP-Originating-Script: 33:rcmail.php
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 07 Jan 2014 15:42:49 +0100
From: andreas@meetr.de
Cc: LKML <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <CALkWK0nL3JOvznns2vApzV9+d1JDLgLX=x=6epw-JMEzANMWDA@mail.gmail.com>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
 <20140107135409.GA21190@thinkpad-t410>
 <CALkWK0nL3JOvznns2vApzV9+d1JDLgLX=x=6epw-JMEzANMWDA@mail.gmail.com>
Message-ID: <ab8110369e392324f0d90368d638bc38@meetr.de>
User-Agent: Roundcube Webmail/0.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-01-07 15:30, schrieb Ramkumar Ramachandra:
> Seth Forshee wrote:

>>  3. So what is really wanted is to be able to mux just the DDC over to
>>     the IGPU when the device is initialized to read the panel mode. 
>> One
>>     possible problem is that the hw might not support muxing the DDC
>>     separately, but Apple hw does so we'll ignore that for now. The
>>     basic code for muxing only the DDC isn't too difficult, and I had
>>     some patches for this at one point. The problem is that the 
>> handler
>>     must register with vga_switcheroo before this is possible, so
>>     there's a module initialization ordering issue that wasn't easily
>>     solved. Maybe now it would be possible to do something with
>>     EPROBE_DEFER, though I'm not sure how i915 would know whether or 
>> not
>>     it should wait for a switcheroo handler.
> 
> I didn't understand much of the above; I suppose it'll start making
> sense when I'm deeper into the issue.
> 

You can switch the line used to detect the display separately from the 
line which is used to display the picture, so you can just switch DDC to 
the intel card when you know it will try to detect the display, without 
having to introduce flickering. There were a few different versions of 
patches that did this, I think this one is the latest: 
http://lists.freedesktop.org/archives/dri-devel/2012-September/027528.html

Sorry that I forgot about this yesterday, it has been quite some time 
since I worked on this.
