Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbaGPMwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:52:50 -0400
Received: from admin.comprocs.com ([12.186.155.30]:63077 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932146AbaGPMws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:52:48 -0400
X-Greylist: delayed 802 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 08:52:47 EDT
X-BYPSHEADER: 959415
X-SMScore: -200
Message-ID: <53C67285.4010008@compro.net>
Date: Wed, 16 Jul 2014 08:39:33 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>
CC: lidza.louina@gmail.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8 RESEND] staging: dgap: introduce dgap_cleanup_nodes()
References: <20140715091425.GA19095@devel.8.8.4.4> <790027403.325559.1405438239093.JavaMail.root@mx2.compro.net>
In-Reply-To: <790027403.325559.1405438239093.JavaMail.root@mx2.compro.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 11:30 AM, Greg KH wrote:
> On Tue, Jul 15, 2014 at 06:14:25PM +0900, Daeseok Youn wrote:
>> When a configration file is parsed with dgap_parsefile(),
>> makes nodes for saving configrations for board.
>
> configuration files should not be parsed in the kernel at all.  That
> logic should be removed as it should not be needed.
>
> Mark, can you verify that this is not needed with your hardware anymore?
>

As far as I can see it is still needed. If no config file, no devices 
are created and configured. I had planned to remove that code such that 
all the different cards supported are still supported. Even though I 
only have 2 different types of cards. I Just haven't got to it yet. I 
realize "configuration files should not be parsed in the kernel" and I'm 
certainly not going to argue that. But the way it is, it allows user 
land to define board order and even device node names (additional links 
to the actual device). No matter where boards are installed and found by 
the kernel, you have persistent naming.  I guess all that can be done 
with udev (well, sort of anyway).

There are also options in the config file that should be passed in as 
module parameters
and I planned to do that part before messing with the config file code.

We also have this "DIGI_EXPANDERS_SUPPORTED" thingy. I have none of 
these cards. These cards interrogate the expander to find out how many 
ports there are. Then configure accordingly. Should we just remove all 
that code and NOT support expanders since we don't currently have the 
hardware to test?

I will update from your current git tree and test this week. I've been 
swamped lately and unable to do much. I thought I'd be available to do 
some more work but things come up as you know.

Regards
Mark

