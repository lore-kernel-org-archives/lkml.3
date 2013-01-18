Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3ARPuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:50:05 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11800 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3ARPuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:50:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 18 Jan 2013 07:49:02 -0800
Message-ID: <50F96F08.7090705@nvidia.com>
Date: Fri, 18 Jan 2013 21:19:28 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Stephen Warren <swarren@nvidia.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: tegra: Switch to using struct tty_port
References: <1358429505-31746-1-git-send-email-thierry.reding@avionic-design.de> <50F82FE7.9090403@wwwdotorg.org> <20130118083756.GA3303@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130118083756.GA3303@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 02:07 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Thu, Jan 17, 2013 at 10:07:51AM -0700, Stephen Warren wrote:
>> On 01/17/2013 06:31 AM, Thierry Reding wrote:
>>> Many of the tty functions were converted to use a struct tty_port
>>> instead of a struct tty_struct. Update the Tegra driver accordingly to
>>> avoid build breakage.
>> I tested that this does indeed fix the build warnings. I didn't test the
>> resultant driver.
> I wonder if this would have been caught earlier if it had errored out
> instead of outputting lots of warnings. Looking at the gcc documentation
> there doesn't seem to be a way to turn this kind of warning into an
> error. That would leave -Werror as the only option to have the compiler
> abort on this kind of warning.
>
> Globally enabling -Werror might not be a good idea and I'm sure it must
> have been discussed in the past (even though Google doesn't show any
> references). In this particular case the warnings are actually severe
> errors and are very likely to cause buggy behaviour so it would be good
> to catch them at compile time. Warnings are unfortunately quite easy to
> ignore.
>
> I know I can always use EXTRA_CFLAGS to change this for local builds,
> but maybe getting more people to do this would be worthwhile.
>

There was no issue when patch created. The change happen in the api with 
same time when patch created and so become out of sync.

API changed with commit on 1/16. Serial driver also get added on 1/16.

Author: Jiri Slaby <jslaby@suse.cz>  2013-01-03 20:23:06
Committer: Greg Kroah-Hartman <gregkh@linuxfoundation.org> 2013-01-16 
12:00:15

Follows: v3.8-rc3
Precedes: next-20130117

     TTY: switch tty_flip_buffer_push


