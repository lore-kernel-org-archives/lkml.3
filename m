Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaD0X2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 19:28:42 -0400
Received: from linuxhacker.ru ([217.76.32.60]:50244 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbaD0X2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 19:28:40 -0400
Subject: Re: [PATCH 5/5] staging/lustre/lnet: fix potential null pointer dereference
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140427223925.GC1563@kroah.com>
Date: Sun, 27 Apr 2014 19:28:27 -0400
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Dmitry Eremin <dmitry.eremin@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <207D440C-EF42-45AC-A845-130985E215EA@linuxhacker.ru>
References: <1398633446-16719-1-git-send-email-green@linuxhacker.ru> <1398633446-16719-6-git-send-email-green@linuxhacker.ru> <20140427223925.GC1563@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Apr 27, 2014, at 6:39 PM, Greg Kroah-Hartman wrote:
>> 
>> -	lnet_ni_notify_locked(ni, lp);
>> +	if (ni != NULL)
>> +		lnet_ni_notify_locked(ni, lp);
> 
> Why can't lnet_ni_notify_locked() accept NULL as an input?

It makes no sense, because then there is nowhere to send the notification.
That said, it appears a race is possible where one caller updated let_peer structure to ask for a notification
and then we fell through here with a NULL ni and called into lnet_ni_notify_locked
where we'd try to dereference this NULL ni.
But this is the only called that accepts separate ni and lp, where as the only other caller gets them from the same struct
where they are updated more in sync.

I guess it makes sense to update lnet_ni_notify_locked as a future-proofing excercise.

Thanks, I'll update this patch.

Bye,
    Oleg