Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaINSWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 14:22:36 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62328 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaINSWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 14:22:34 -0400
Message-ID: <5415DCE6.301@gmail.com>
Date: Sun, 14 Sep 2014 20:22:30 +0200
From: =?ISO-8859-1?Q?Stephan_M=FCller?= <fruktopus@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] Change userspace MKDEV, MAJOR, MINOR-macros from 8+8
 bit, to 12+20 bit layout
References: <5415D1E0.3020905@gmail.com> <20140914174622.GA10315@kroah.com>
In-Reply-To: <20140914174622.GA10315@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.09.2014 19:46, schrieb Greg KH:
> On Sun, Sep 14, 2014 at 07:35:28PM +0200, Stephan Müller wrote:
>> Delete old userspace-only versions (8+8 bit). Instead expose the kernel-space
>> definitions (12+20 bit).
>>
>> Signed-off-by: Stephan Mueller <fruktopus@gmail.com>
>> ---
>>
>> Browsing some code I found that user-space and kernel-space macros for (un-)packing major/minor device numbers differ. The user-space ones using still the old 16 bit scheme. There was no explaining comment around and most libraries have their own macros anyway so it should not be a problematic UAPI change. So IMHO we could win some coherence in abandon this discrepancy.
>> Please correct me if I am wrong.
> 
> You are wrong, we can't change this api, things will break :(
> 
> sorry,
> 
> greg k-h

I kind of expected this. The #ifndef __KERNEL__ was suspicious..

 thanks
