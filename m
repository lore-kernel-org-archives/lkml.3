Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbbAMSo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:44:27 -0500
Received: from box2.japko.eu ([91.121.152.53]:52328 "EHLO box2.japko.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbbAMSoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:44:25 -0500
Date: Tue, 13 Jan 2015 19:42:28 +0100
From: Krzysztof Adamski <k@japko.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: Use ether_addr_copy() on vnt_private
 members.
Message-ID: <20150113184227.GK30114@box2.japko.eu>
References: <20141222161541.GA11764@box2.japko.eu>
 <20150113034212.GA16174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20150113034212.GA16174@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 07:42:12PM -0800, Greg Kroah-Hartman wrote:
>On Mon, Dec 22, 2014 at 05:15:41PM +0100, Krzysztof Adamski wrote:
>> This patch fixes checkpatch.pl warning:
>> WARNING: Prefer ether_addr_copy() over memcpy() if the Ethernet
>> addresses are __aligned(2)
>>
>> current_net_addr and permanent_net_addr members of vnt_private alignment
>> is changed to at last 16 bits so that ether_addr_copy can be safely used
>> on them.
>>
>> buf->data is of type ieee80211_cts which is already properly aligned.
>>
>> Signed-off-by: Krzysztof Adamski <k@japko.eu>
>> ---
>> drivers/staging/vt6656/device.h   |    4 ++--
>> drivers/staging/vt6656/main_usb.c |    3 ++-
>> drivers/staging/vt6656/rxtx.c     |    4 ++--
>> 3 files changed, 6 insertions(+), 5 deletions(-)
>
>Doesn't apply to my tree :(

Strange, I was trying to apply this on your tree to fix any conflicts 
but apparently you already has this patch in your staging-testing 
branch. And as far as I can tell I only sent it once to you.
